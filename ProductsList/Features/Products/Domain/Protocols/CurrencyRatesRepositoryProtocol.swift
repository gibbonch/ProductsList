protocol CurrencyRatesRepositoryProtocol {
    func fetchCurrencyRates() -> Result<[CurrencyRate], Error>
}
