struct CurrencyRate {
    let fromCurrency: CurrencyCode
    let toCurrency: CurrencyCode
    let multiplier: Multiplier
}

typealias Multiplier = Double

enum CurrencyEnvironment: CurrencyCode {
    case base = "GBP"
    case crossRate = "USD"
}
