import Foundation

final class CurrencyConverter: CurrencyConverterProtocol {
    
    // MARK: - Private Properties
    
    private var memo: [String: Double] = [:]
    private var rates: [CurrencyRate] = []
    private var crossRateCurrency: CurrencyCode
    
    // MARK: - Lifecycle
    
    init(crossRateCurrency: CurrencyCode = CurrencyEnvironment.crossRate.rawValue) {
        self.crossRateCurrency = crossRateCurrency
    }
    
    // MARK: - Internal Methods
    
    func loadRates(_ rates: [CurrencyRate]) {
        self.rates = rates
        memo.removeAll()
    }
    
    func convert(from amount: Amount, to currency: CurrencyCode) throws -> Amount {
        guard amount.value >= 0 else {
            throw CurrencyConverterError.invalidAmount
        }
        
        if amount.code == currency {
            return amount
        }
        
        let rate = try findConversionRate(from: amount.code, to: currency)
        let convertedValue = amount.value * rate
        
        return Amount(value: convertedValue, code: currency)
    }
    
    // MARK: - Private Methods
    
    private func findConversionRate(from: CurrencyCode, to: CurrencyCode) throws -> Double {
        let memoKey = "\(from)-\(to)"
        
        if let cachedRate = memo[memoKey] {
            return cachedRate
        }
        
        if let directRate = findDirectRate(from: from, to: to) {
            memo[memoKey] = directRate
            return directRate
        }
        
        if let crossRate = findCrossRate(from: from, to: to) {
            memo[memoKey] = crossRate
            return crossRate
        }
        
        throw CurrencyConverterError.rateNotFound
    }
    
    private func findDirectRate(from: CurrencyCode, to: CurrencyCode) -> Double? {
        rates.first { $0.fromCurrency == from && $0.toCurrency == to }?.multiplier
    }
    
    private func findCrossRate(from: CurrencyCode, to: CurrencyCode) -> Double? {
        guard let rateToBase = findDirectRate(from: from, to: crossRateCurrency),
              let rateFromBase = findDirectRate(from: crossRateCurrency, to: to) else {
            return nil
        }
        return rateToBase * rateFromBase
    }
}
