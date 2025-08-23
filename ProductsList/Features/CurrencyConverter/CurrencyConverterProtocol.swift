protocol CurrencyConverterProtocol {
    func loadRates(_ rates: [CurrencyRate])
    func convert(from amount: Amount, to currency: CurrencyCode) throws -> Amount
}
