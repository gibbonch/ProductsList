import XCTest
@testable import ProductsList

final class GetProductSummariesUseCaseTests: XCTestCase {
    
    private var mockRepository: MockTransactionsRepository!
    private var sut: GetProductSummariesUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTransactionsRepository()
        sut = GetProductSummariesUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testExecute_callsRepositoryFetchAllTransactions() {
        let expectedCallCount = 1
        setupMockRepositoryWithValidTransactions()
        
        let expectation = expectation(description: "Completion called")
        sut.execute { _ in expectation.fulfill() }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockRepository.fetchAllTransactionsCallCount, expectedCallCount)
    }
    
    func testExecute_returnsSuccess_whenRepositoryReturnsValidTransactions() {
        setupMockRepositoryWithValidTransactions()
        
        let expectation = expectation(description: "Success completion")
        sut.execute { result in
            switch result {
            case .success(let summaries):
                XCTAssertEqual(summaries.count, 3)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_returnsFailure_whenRepositoryReturnsError() {
        setupMockRepositoryWithError()
        
        let expectation = expectation(description: "Failure completion")
        sut.execute { result in
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
    
    func testExecute_groupsTransactionsBySku_correctly() {
        mockRepository.mockTransactions = [
            createTransaction(sku: "A1"),
            createTransaction(sku: "A1"),
            createTransaction(sku: "A1"),
            createTransaction(sku: "B1"),
            createTransaction(sku: "B1")
        ]
        mockRepository.mockError = nil
        
        let expectation = expectation(description: "Grouped correctly")
        sut.execute { result in
            switch result {
            case .success(let summaries):
                XCTAssertEqual(summaries.count, 2)
                
                let aTypeSummary = summaries.first { $0.sku == "A1" }
                let bTypeSummary = summaries.first { $0.sku == "B1" }
                
                XCTAssertNotNil(aTypeSummary)
                XCTAssertNotNil(bTypeSummary)
                XCTAssertEqual(aTypeSummary?.count, 3)
                XCTAssertEqual(bTypeSummary?.count, 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_sortsSummariesBySku_alphabetically() {
        mockRepository.mockTransactions = [
            createTransaction(sku: "C"),
            createTransaction(sku: "A"),
            createTransaction(sku: "B")
        ]
        mockRepository.mockError = nil
        
        let expectation = expectation(description: "Sorted alphabetically")
        sut.execute { result in
            switch result {
            case .success(let summaries):
                XCTAssertEqual(summaries.count, 3)
                XCTAssertEqual(summaries[0].sku, "A")
                XCTAssertEqual(summaries[1].sku, "B")
                XCTAssertEqual(summaries[2].sku, "C")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_returnsEmptyArray_whenNoTransactions() {
        setupMockRepositoryWithEmptyTransactions()
        
        let expectation = expectation(description: "Empty array returned")
        sut.execute { result in
            switch result {
            case .success(let summaries):
                XCTAssertEqual(summaries.count, 0)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExecute_executesOnBackgroundQueue() {
        setupMockRepositoryWithValidTransactions()
        
        let expectation = expectation(description: "Background queue execution")
        var isMainQueue = true
        
        sut.execute { _ in
            isMainQueue = Thread.isMainThread
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertFalse(isMainQueue, "Expected execution on background queue")
    }
    
    // MARK: - Helpers
    
    private func setupMockRepositoryWithValidTransactions() {
        mockRepository.mockTransactions = [
            createTransaction(sku: "A"),
            createTransaction(sku: "B"),
            createTransaction(sku: "C")
        ]
        mockRepository.mockError = nil
    }
    
    private func setupMockRepositoryWithError() {
        mockRepository.mockTransactions = []
        mockRepository.mockError = TransactionsRepositoryError.invalidSku
    }
    
    private func setupMockRepositoryWithEmptyTransactions() {
        mockRepository.mockTransactions = []
        mockRepository.mockError = nil
    }
    
    
    private func createTransaction(sku: Sku) -> Transaction {
        Transaction(
            sku: sku,
            amount: Amount(value: 100, code: "USD")
        )
    }
}
