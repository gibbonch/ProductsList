import XCTest
@testable import ProductsList

final class CurrencyConverterTests: XCTestCase {
    
    private var sut: CurrencyConverter!
    private var from: CurrencyCode!
    private var to: CurrencyCode!
    private var crossRateCurrency: CurrencyCode!
    
    override func setUp() {
        super.setUp()
        from = "CAD"
        to = "GBP"
        crossRateCurrency = "USD"
        sut = CurrencyConverter(crossRateCurrency: crossRateCurrency)
    }
    
    override func tearDown() {
        from = nil
        to = nil
        crossRateCurrency = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testConvert_returnsCorrectAmount_whenHasDirectRate() {
        // Given
        let value = 1.0
        let multiplier = 0.77
        let expectedValue = value * multiplier
        let amount = Amount(value: value, code: from)
        let crossRates = [CurrencyRate(fromCurrency: from, toCurrency: to, multiplier: multiplier)]
        sut.loadRates(crossRates)
        
        // When
        let resultAmount = try? sut.convert(from: amount, to: to)
        
        // Then
        XCTAssertNotNil(resultAmount)
        XCTAssertEqual(resultAmount?.code, to)
        XCTAssertEqual(resultAmount?.value, expectedValue)
    }
    
    func testConvert_returnsCorrectAmount_whenHasCrossRatePath() {
        // Given
        let value = 1.0
        let multiplierToCrossRate = 0.77
        let multiplierFromCrossRate = 1.1
        
        let expectedValue = value * multiplierToCrossRate * multiplierFromCrossRate
        let amount = Amount(value: value, code: from)
        let crossRates = [CurrencyRate(fromCurrency: from, toCurrency: crossRateCurrency, multiplier: multiplierToCrossRate),
                          CurrencyRate(fromCurrency: crossRateCurrency, toCurrency: to, multiplier: multiplierFromCrossRate)]
        sut.loadRates(crossRates)
        
        // When
        let resultAmount = try? sut.convert(from: amount, to: to)
        
        // Then
        XCTAssertNotNil(resultAmount)
        XCTAssertEqual(resultAmount?.code, to)
        XCTAssertEqual(resultAmount?.value, expectedValue)
    }
    
    func testConvert_returnsSameAmount_whenConvertingToSameCurrency() {
        // Given
        let value = 1.0
        let amount = Amount(value: value, code: to)
        
        // When
        let resultAmount = try? sut.convert(from: amount, to: to)
        
        // Then
        XCTAssertNotNil(resultAmount)
        XCTAssertEqual(resultAmount?.code, to)
        XCTAssertEqual(resultAmount?.value, value)
    }
    
    func testConvert_throwsError_whenHasNotCrossRatePath() {
        let amount = Amount(value: 1.0, code: from)
        XCTAssertThrowsError(try sut.convert(from: amount, to: to))
    }
    
    func testConvert_throwsError_whenInvalidAmount() {
        let invalidAmount = Amount(value: -1.0, code: from)
        XCTAssertThrowsError(try sut.convert(from: invalidAmount, to: to))
    }
}
