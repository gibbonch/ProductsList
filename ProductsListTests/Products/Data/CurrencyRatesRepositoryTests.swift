import XCTest
@testable import ProductsList

final class CurrencyRatesRepositoryTests: XCTestCase {
    
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
        let _ = CurrencyRatesRepository(plistReader: plistReader)
        XCTAssertEqual(plistReader.readCallCount, expectedCount)
    }
    
    func testInit_callsReadMethodOnCorrectFile() {
        let expectedFile = "rates"
        setupPlistReaderWithValidData()
        let _ = CurrencyRatesRepository(plistReader: plistReader)
        XCTAssertNotNil(plistReader.capturedFile)
        XCTAssertEqual(plistReader.capturedFile, expectedFile)
    }
    
    func testInit_callsReadWithCorrectType() {
        setupPlistReaderWithValidData()
        let _ = CurrencyRatesRepository(plistReader: plistReader)
        XCTAssertNotNil(plistReader.capturedType)
        XCTAssertTrue(plistReader.capturedType == [CurrencyRateDTO].self)
    }
    
    func testInit_storesErrorFromPlistReader() {
        setupPlistReaderWithError()
        let sut = CurrencyRatesRepository(plistReader: plistReader)
        
        let result = sut.fetchCurrencyRates()
        
        switch result {
        case .success:
            XCTFail("Expected failure due to initialization error")
        case .failure(let error):
            XCTAssertTrue(error is PlistReaderError)
        }
    }
    
    func testFetchCurrencyRates_returnsSuccess_whenValidDTOs() {
        setupPlistReaderWithValidData()
        let sut = CurrencyRatesRepository(plistReader: plistReader)
        
        let result = sut.fetchCurrencyRates()
        
        switch result {
        case .success(let rates):
            XCTAssertEqual(rates.count, 6)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testFetchCurrencyRates_returnsFailure_whenPlistReaderThrowsError() {
        setupPlistReaderWithError()
        let sut = CurrencyRatesRepository(plistReader: plistReader)
        
        let result = sut.fetchCurrencyRates()
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertTrue(error is PlistReaderError)
            XCTAssertEqual(error as? PlistReaderError, .fileNotFound)
        }
    }
    
    func testFetchCurrencyRates_filtersInvalidDTOs_whenSomeDTOsAreInvalid() {
        plistReader.mockData = [
            CurrencyRateDTO(from: "USD", to: "GBP", rate: "0.77"), // valid
            CurrencyRateDTO(from: "", to: "USD", rate: "1.3"),     // invalid
            CurrencyRateDTO(from: "USD", to: "", rate: "1.09"),    // invalid
            CurrencyRateDTO(from: "CAD", to: "USD", rate: "invalid"), // invalid
            CurrencyRateDTO(from: "GBP", to: "AUD", rate: "0.83")  // valid
        ]
        plistReader.error = nil
        
        let sut = CurrencyRatesRepository(plistReader: plistReader)
        
        let result = sut.fetchCurrencyRates()
        
        switch result {
        case .success(let rates):
            XCTAssertEqual(rates.count, 2)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testFetchCurrencyRates_returnsSameResult_whenCalledMultipleTimes() {
        setupPlistReaderWithValidData()
        let sut = CurrencyRatesRepository(plistReader: plistReader)
        
        let firstResult = sut.fetchCurrencyRates()
        let secondResult = sut.fetchCurrencyRates()
        
        guard case .success(let firstRates) = firstResult,
              case .success(let secondRates) = secondResult else {
            XCTFail("Expected both results to be successful")
            return
        }
        
        XCTAssertEqual(firstRates.count, secondRates.count)
        XCTAssertEqual(plistReader.readCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func setupPlistReaderWithError() {
        plistReader.error = .fileNotFound
        plistReader.mockData = nil
    }
    
    private func setupPlistReaderWithValidData() {
        plistReader.mockData = [CurrencyRateDTO(from: "USD", to: "GBP", rate: "0.77"),
                                CurrencyRateDTO(from: "GBP", to: "USD", rate: "1.3"),
                                CurrencyRateDTO(from: "USD", to: "CAD", rate: "1.09"),
                                CurrencyRateDTO(from: "CAD", to: "USD", rate: "0.92"),
                                CurrencyRateDTO(from: "GBP", to: "AUD", rate: "0.83"),
                                CurrencyRateDTO(from: "AUD", to: "GBP", rate: "1.2")]
        plistReader.error = nil
    }
}
