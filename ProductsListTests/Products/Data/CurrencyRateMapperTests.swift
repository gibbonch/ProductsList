import XCTest
@testable import ProductsList

final class CurrencyRateMapperTests: XCTestCase {
    
    func testMapToDomain_returnsDomainModel_whenValidDTO() {
        // Given
        let expectedMultiplier = 0.77
        let from = "USD"
        let to = "GBP"
        let dto = CurrencyRateDTO(from: from, to: to, rate: expectedMultiplier.description)
        
        // When
        let domainModel = CurrencyRateMapper.mapToDomain(dto: dto)
        
        // Then
        XCTAssertNotNil(domainModel)
        XCTAssertEqual(domainModel?.fromCurrency, from)
        XCTAssertEqual(domainModel?.toCurrency, to)
        XCTAssertEqual(domainModel?.multiplier, expectedMultiplier)
    }
    
    func testMapToDomain_returnsNil_whenInvalidCurrencyCode() {
        // Given
        let invalidCode = "***"
        let dto = CurrencyRateDTO(from: invalidCode, to: "GBP", rate: "0.77")
        
        // When
        let domainModel = CurrencyRateMapper.mapToDomain(dto: dto)
        
        // Then
        XCTAssertNil(domainModel)
    }
    
    func testMapToDomain_returnsNil_whenInvalidRate() {
        // Given
        let invalidRate = "***"
        let dto = CurrencyRateDTO(from: "USD", to: "GBP", rate: invalidRate)
        
        // When
        let domainModel = CurrencyRateMapper.mapToDomain(dto: dto)
        
        // Then
        XCTAssertNil(domainModel)
    }
    
    func testMapToDomain_returnsNil_whenRateLessThanZero() {
        // Given
        let invalidRate = "-10"
        let dto = CurrencyRateDTO(from: "USD", to: "GBP", rate: invalidRate)
        
        // When
        let domainModel = CurrencyRateMapper.mapToDomain(dto: dto)
        
        // Then
        XCTAssertNil(domainModel)
    }
}
