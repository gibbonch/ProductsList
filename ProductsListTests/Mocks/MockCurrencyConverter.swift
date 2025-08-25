@testable import ProductsList

final class MockCurrencyConverter: CurrencyConverterProtocol {
    
    var mockConvertedAmount: Amount?
    var mockError: Error?
    
    var loadRatesCallCount = 0
    var convertCallCount = 0
    var capturedRates: [CurrencyRate]?
    var capturedAmount: Amount?
    var capturedCurrency: CurrencyCode?
    
    func loadRates(_ rates: [CurrencyRate]) {
        loadRatesCallCount += 1
        capturedRates = rates
    }
    
    func convert(from amount: Amount, to currency: CurrencyCode) throws -> Amount {
        convertCallCount += 1
        capturedAmount = amount
        capturedCurrency = currency
        
        if let mockError {
            throw mockError
        }
        
        return mockConvertedAmount ?? Amount(value: amount.value, code: currency)
    }
}
