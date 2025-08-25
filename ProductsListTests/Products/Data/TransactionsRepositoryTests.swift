import XCTest
@testable import ProductsList

final class TransactionsRepositoryTests: XCTestCase {
    
    private var plistReader: MockPlistReader!
    
    override func setUp() {
        super.setUp()
        plistReader = MockPlistReader()
    }
    
    override func tearDown() {
        plistReader = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInit_callsPlistReaderSingleTime() {
        let expectedCount = 1
        setupPlistReaderWithValidData()
        let _ = TransactionsRepository(plistReader: plistReader)
        XCTAssertEqual(plistReader.readCallCount, expectedCount)
    }
    
    func testInit_callsReadMethodOnCorrectFile() {
        let expectedFile = "transactions"
        setupPlistReaderWithValidData()
        let _ = TransactionsRepository(plistReader: plistReader)
        XCTAssertNotNil(plistReader.capturedFile)
        XCTAssertEqual(plistReader.capturedFile, expectedFile)
    }
    
    func testInit_callsReadWithCorrectType() {
        setupPlistReaderWithValidData()
        let _ = TransactionsRepository(plistReader: plistReader)
        XCTAssertNotNil(plistReader.capturedType)
        XCTAssertTrue(plistReader.capturedType == [TransactionDTO].self)
    }
    
    func testInit_storesErrorFromPlistReader() {
        setupPlistReaderWithError()
        let sut = TransactionsRepository(plistReader: plistReader)
        
        let result = sut.fetchAllTransactions()
        
        switch result {
        case .success:
            XCTFail("Expected failure due to initialization error")
        case .failure(let error):
            XCTAssertTrue(error is PlistReaderError)
        }
    }
    
    
    func testFetchAllTransactions_returnsSuccess_whenValidDTOs() {
        setupPlistReaderWithValidData()
        let sut = TransactionsRepository(plistReader: plistReader)
        
        let result = sut.fetchAllTransactions()
        
        switch result {
        case .success(let transactions):
            XCTAssertEqual(transactions.count, 4)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testFetchAllTransactions_returnsFailure_whenPlistReaderThrowsError() {
        setupPlistReaderWithError()
        let sut = TransactionsRepository(plistReader: plistReader)
        
        let result = sut.fetchAllTransactions()
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertTrue(error is PlistReaderError)
            XCTAssertEqual(error as? PlistReaderError, .fileNotFound)
        }
    }
    
    func testFetchAllTransactions_filtersInvalidDTOs_whenSomeDTOsAreInvalid() {
        plistReader.mockData = [
            TransactionDTO(amount: "10.50", currency: "USD", sku: "T001"), // valid
            TransactionDTO(amount: "", currency: "EUR", sku: "T002"), // invalid
            TransactionDTO(amount: "25.75", currency: "invalid", sku: "T003"), // invalid
            TransactionDTO(amount: "30.00", currency: "CAD", sku: ""), // invalid
            TransactionDTO(amount: "30.00", currency: "CAD", sku: "T004") // valid
        ]
        plistReader.error = nil
        
        let sut = TransactionsRepository(plistReader: plistReader)
        
        let result = sut.fetchAllTransactions()
        
        switch result {
        case .success(let transactions):
            XCTAssertEqual(transactions.count, 2)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testFetchAllTransactions_returnsSameResult_whenCalledMultipleTimes() {
        setupPlistReaderWithValidData()
        let sut = TransactionsRepository(plistReader: plistReader)
        
        let firstResult = sut.fetchAllTransactions()
        let secondResult = sut.fetchAllTransactions()
        
        guard case .success(let firstTransactions) = firstResult,
              case .success(let secondTransactions) = secondResult else {
            XCTFail("Expected both results to be successful")
            return
        }
        
        XCTAssertEqual(firstTransactions.count, secondTransactions.count)
        XCTAssertEqual(plistReader.readCallCount, 1)
    }
    
    func testFetchTransactionsWithSku_returnsSuccess_whenValidSkuExists() {
        setupPlistReaderWithValidData()
        let sut = TransactionsRepository(plistReader: plistReader)
        let targetSku = Sku("T001")
        
        let result = sut.fetchTransactions(with: targetSku)
        
        switch result {
        case .success(let transactions):
            XCTAssertEqual(transactions.count, 1)
            XCTAssertEqual(transactions.first?.sku, targetSku)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testFetchTransactionsWithSku_returnsMultipleTransactions_whenMultipleTransactionsExistForSku() {
        plistReader.mockData = [
            TransactionDTO(amount: "10.50", currency: "USD", sku: "T001"),
            TransactionDTO(amount: "15.00", currency: "EUR", sku: "T001"),
            TransactionDTO(amount: "25.75", currency: "GBP", sku: "T002"),
            TransactionDTO(amount: "30.00", currency: "CAD", sku: "T001")
        ]
        plistReader.error = nil
        let sut = TransactionsRepository(plistReader: plistReader)
        let targetSku = Sku("T001")
        
        let result = sut.fetchTransactions(with: targetSku)
        
        switch result {
        case .success(let transactions):
            XCTAssertEqual(transactions.count, 3)
            XCTAssertTrue(transactions.allSatisfy { $0.sku == targetSku })
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testFetchTransactionsWithSku_returnsInvalidSkuError_whenSkuDoesNotExist() {
        setupPlistReaderWithValidData()
        let sut = TransactionsRepository(plistReader: plistReader)
        let nonExistentSku = Sku("INVALID")
        
        let result = sut.fetchTransactions(with: nonExistentSku)
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertTrue(error is TransactionsRepositoryError)
            XCTAssertEqual(error as? TransactionsRepositoryError, .invalidSku)
        }
    }
    
    func testFetchTransactionsWithSku_returnsFailure_whenInitializationError() {
        setupPlistReaderWithError()
        let sut = TransactionsRepository(plistReader: plistReader)
        let targetSku = Sku("T001")
        
        let result = sut.fetchTransactions(with: targetSku)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to initialization error")
        case .failure(let error):
            XCTAssertTrue(error is PlistReaderError)
        }
    }
    
    func testFetchTransactionsWithSku_returnsSameResult_whenCalledMultipleTimes() {
        setupPlistReaderWithValidData()
        let sut = TransactionsRepository(plistReader: plistReader)
        let targetSku = Sku("T001")
        
        let firstResult = sut.fetchTransactions(with: targetSku)
        let secondResult = sut.fetchTransactions(with: targetSku)
        
        guard case .success(let firstTransactions) = firstResult,
              case .success(let secondTransactions) = secondResult else {
            XCTFail("Expected both results to be successful")
            return
        }
        
        XCTAssertEqual(firstTransactions.count, secondTransactions.count)
        XCTAssertEqual(plistReader.readCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func setupPlistReaderWithError() {
        plistReader.error = .fileNotFound
        plistReader.mockData = nil
    }
    
    private func setupPlistReaderWithValidData() {
        plistReader.mockData = [
            TransactionDTO(amount: "10.50", currency: "USD", sku: "T001"),
            TransactionDTO(amount: "15.00", currency: "EUR", sku: "T002"),
            TransactionDTO(amount: "25.75", currency: "GBP", sku: "T003"),
            TransactionDTO(amount: "30.00", currency: "CAD", sku: "T004")
        ]
        plistReader.error = nil
    }
}
