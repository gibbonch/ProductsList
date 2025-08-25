import XCTest
@testable import ProductsList

final class TransactionMapperTests: XCTestCase {
    
    func testMapToDomain_returnsDomainModel_whenValidDTO() {
        // Given
        let amount = 1.0
        let currency = "USD"
        let sku = "123"
        let dto = TransactionDTO(amount: amount.description, currency: currency, sku: sku)
        
        // When
        let domainModel = TransactionMapper.mapToDomain(dto: dto)
        
        // Then
        XCTAssertNotNil(domainModel)
        XCTAssertEqual(domainModel?.sku, sku)
        XCTAssertEqual(domainModel?.amount.code, currency)
        XCTAssertEqual(domainModel?.amount.value, amount)
    }
    
    func testMapToDomain_returnsNil_whenInvalidCurrency() {
        // Given
        let invalidCurrency = "***"
        let dto = TransactionDTO(amount: "1.0", currency: invalidCurrency, sku: "123")
        
        // When
        let domainModel = TransactionMapper.mapToDomain(dto: dto)
        
        // Then
        XCTAssertNil(domainModel)
    }
    
    func testMapToDomain_returnsNil_whenInvalidAmount() {
        // Given
        let invalidAmount = ""
        let dto = TransactionDTO(amount: invalidAmount, currency: "USD", sku: "123")
        
        // When
        let domainModel = TransactionMapper.mapToDomain(dto: dto)
        
        // Then
        XCTAssertNil(domainModel)
    }
}
