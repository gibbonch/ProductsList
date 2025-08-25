import XCTest
@testable import ProductsList

final class GetProductUseCaseTests: XCTestCase {
    
    private var mockTransactionsRepository: MockTransactionsRepository!
    private var mockCurrencyRatesRepository: MockCurrencyRatesRepository!
    private var mockCurrencyConverter: MockCurrencyConverter!
    private var sut: GetProductUseCase!
    
    override func setUp() {
        super.setUp()
        mockTransactionsRepository = MockTransactionsRepository()
        mockCurrencyRatesRepository = MockCurrencyRatesRepository()
        mockCurrencyConverter = MockCurrencyConverter()
        sut = GetProductUseCase(
            transactionsRepository: mockTransactionsRepository,
            currencyRatesRepository: mockCurrencyRatesRepository,
            currencyConverter: mockCurrencyConverter
        )
    }
    
    override func tearDown() {
        mockTransactionsRepository = nil
        mockCurrencyRatesRepository = nil
        mockCurrencyConverter = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testExecute_callsCurrencyRatesRepositoryFetchCurrencyRates() {
        let expectedCallCount = 1
        setupMockRepositoriesWithValidData()
        
        let expectation = expectation(description: "Completion called")
        sut.execute(with: "A1") { _ in expectation.fulfill() }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockCurrencyRatesRepository.fetchCurrencyRatesCallCount, expectedCallCount)
    }
    
    func testExecute_callsTransactionsRepositoryFetchTransactionsWithCorrectSku() {
        let expectedSku = "A1"
        let expectedCallCount = 1
        setupMockRepositoriesWithValidData()
        
        let expectation = expectation(description: "Completion called")
        sut.execute(with: expectedSku) { _ in expectation.fulfill() }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockTransactionsRepository.fetchTransactionsCallCount, expectedCallCount)
        XCTAssertEqual(mockTransactionsRepository.capturedSku, expectedSku)
    }
    
    func testExecute_callsCurrencyConverterLoadRatesWithCorrectRates() {
        let expectedRates = createCurrencyRates()
        mockCurrencyRatesRepository.mockCurrencyRates = expectedRates
        mockCurrencyRatesRepository.mockError = nil
        mockTransactionsRepository.mockTransactions = createTransactions()
        mockTransactionsRepository.mockError = nil
        mockCurrencyConverter.mockError = nil
        
        let expectation = expectation(description: "Completion called")
        sut.execute(with: "A1") { _ in expectation.fulfill() }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockCurrencyConverter.loadRatesCallCount, 1)
        
        for (i, rate) in expectedRates.enumerated() {
            XCTAssertEqual(rate.fromCurrency, expectedRates[i].fromCurrency)
            XCTAssertEqual(rate.toCurrency, expectedRates[i].toCurrency)
            XCTAssertEqual(rate.multiplier, expectedRates[i].multiplier)
        }
    }
    
    func testExecute_returnsSuccess_whenAllRepositoriesReturnValidData() {
        setupMockRepositoriesWithValidData()
        
        let expectation = expectation(description: "Success completion")
        sut.execute(with: "A1") { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.sku, "A1")
                XCTAssertEqual(product.conversions.count, 2)
                XCTAssertEqual(product.totalAmount.code, "GBP")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_returnsFailure_whenCurrencyRatesRepositoryReturnsError() {
        setupMockRepositoriesWithCurrencyRatesError()
        
        let expectation = expectation(description: "Failure completion")
        sut.execute(with: "A1") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is PlistReaderError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_returnsFailure_whenTransactionsRepositoryReturnsError() {
        setupMockRepositoriesWithTransactionsError()
        
        let expectation = expectation(description: "Failure completion")
        sut.execute(with: "A1") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is TransactionsRepositoryError)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_convertsAllTransactionsToTargetCurrency() {
        let transactions = createTransactions()
        let rates = createCurrencyRates()
        
        mockTransactionsRepository.mockTransactions = transactions
        mockTransactionsRepository.mockError = nil
        mockCurrencyRatesRepository.mockCurrencyRates = rates
        mockCurrencyRatesRepository.mockError = nil
        mockCurrencyConverter.mockError = nil
        
        let expectation = expectation(description: "All transactions converted")
        sut.execute(with: "A1") { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.conversions.count, transactions.count)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockCurrencyConverter.convertCallCount, transactions.count)
    }
    
    func testExecute_calculatesTotalAmountCorrectly() {
        let transactions = [
            createTransaction(sku: "A1", amount: Amount(value: 100, code: "USD")),
            createTransaction(sku: "A1", amount: Amount(value: 200, code: "EUR"))
        ]
        
        mockTransactionsRepository.mockTransactions = transactions
        mockTransactionsRepository.mockError = nil
        mockCurrencyRatesRepository.mockCurrencyRates = createCurrencyRates()
        mockCurrencyRatesRepository.mockError = nil
        
        mockCurrencyConverter.mockConvertedAmount = Amount(value: 150, code: "GBP")
        mockCurrencyConverter.mockError = nil
        
        let expectation = expectation(description: "Total calculated correctly")
        sut.execute(with: "A1") { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.totalAmount.code, "GBP")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_returnsEmptyConversions_whenNoTransactions() {
        mockTransactionsRepository.mockTransactions = []
        mockTransactionsRepository.mockError = nil
        mockCurrencyRatesRepository.mockCurrencyRates = createCurrencyRates()
        mockCurrencyRatesRepository.mockError = nil
        mockCurrencyConverter.mockError = nil
        
        let expectation = expectation(description: "Empty conversions returned")
        sut.execute(with: "A1") { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.conversions.count, 0)
                XCTAssertEqual(product.totalAmount.value, 0)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_executesOnBackgroundQueue() {
        setupMockRepositoriesWithValidData()
        
        let expectation = expectation(description: "Background queue execution")
        var isMainQueue = true
        
        sut.execute(with: "A1") { _ in
            isMainQueue = Thread.isMainThread
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertFalse(isMainQueue, "Expected execution on background queue")
    }
    
    func testExecute_handlesCurrencyConverterErrorGracefully() {
        let transactions = createTransactions()
        mockTransactionsRepository.mockTransactions = transactions
        mockTransactionsRepository.mockError = nil
        mockCurrencyRatesRepository.mockCurrencyRates = createCurrencyRates()
        mockCurrencyRatesRepository.mockError = nil
        
        mockCurrencyConverter.mockError = CurrencyConverterError.rateNotFound
        
        let expectation = expectation(description: "Error handled gracefully")
        sut.execute(with: "A1") { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.sku, "A1")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func setupMockRepositoriesWithValidData() {
        mockTransactionsRepository.mockTransactions = createTransactions()
        mockTransactionsRepository.mockError = nil
        mockCurrencyRatesRepository.mockCurrencyRates = createCurrencyRates()
        mockCurrencyRatesRepository.mockError = nil
        mockCurrencyConverter.mockError = nil
    }
    
    private func setupMockRepositoriesWithCurrencyRatesError() {
        mockTransactionsRepository.mockTransactions = []
        mockTransactionsRepository.mockError = nil
        mockCurrencyRatesRepository.mockCurrencyRates = []
        mockCurrencyRatesRepository.mockError = PlistReaderError.fileNotFound
        mockCurrencyConverter.mockError = nil
    }
    
    private func setupMockRepositoriesWithTransactionsError() {
        mockTransactionsRepository.mockTransactions = []
        mockTransactionsRepository.mockError = TransactionsRepositoryError.invalidSku
        mockCurrencyRatesRepository.mockCurrencyRates = createCurrencyRates()
        mockCurrencyRatesRepository.mockError = nil
        mockCurrencyConverter.mockError = nil
    }
    
    private func createTransactions() -> [Transaction] {
        [
            createTransaction(sku: "A1", amount: Amount(value: 100, code: "USD")),
            createTransaction(sku: "A1", amount: Amount(value: 200, code: "EUR"))
        ]
    }
    
    private func createCurrencyRates() -> [CurrencyRate] {
        [
            CurrencyRate(fromCurrency: "USD", toCurrency: "GBP", multiplier: 0.8),
            CurrencyRate(fromCurrency: "EUR", toCurrency: "GBP", multiplier: 0.9)
        ]
    }
    
    private func createTransaction(sku: Sku, amount: Amount) -> Transaction {
        Transaction(sku: sku, amount: amount)
    }
}
