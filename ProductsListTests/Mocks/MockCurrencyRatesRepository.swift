@testable import ProductsList

final class MockCurrencyRatesRepository: CurrencyRatesRepositoryProtocol {
    
    var mockCurrencyRates: [CurrencyRate] = []
    var mockError: Error?
    
    var fetchCurrencyRatesCallCount = 0
    
    func fetchCurrencyRates() -> Result<[CurrencyRate], any Error> {
        fetchCurrencyRatesCallCount += 1
        
        if let mockError {
            return .failure(mockError)
        }
        return .success(mockCurrencyRates)
    }
}
