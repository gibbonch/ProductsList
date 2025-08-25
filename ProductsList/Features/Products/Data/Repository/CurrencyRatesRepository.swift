import Foundation

final class CurrencyRatesRepository: CurrencyRatesRepositoryProtocol {
    
    private static let file = "rates"
    
    private let plistReader: PlistReaderProtocol
    private var currencyRates: [CurrencyRate] = []
    private var initializationError: Error?
    
    init(plistReader: PlistReaderProtocol = PlistReader()) {
        self.plistReader = plistReader
        loadRates()
    }
    
    func fetchCurrencyRates() -> Result<[CurrencyRate], Error> {
        if let initializationError {
            return .failure(initializationError)
        }
        return .success(currencyRates)
    }
    
    private func loadRates() {
        do {
            let rateDTOs = try plistReader.read(file: Self.file, as: [CurrencyRateDTO].self)
            let rates = rateDTOs.compactMap { dto in
                CurrencyRateMapper.mapToDomain(dto: dto)
            }
            
            self.currencyRates = rates
            
        } catch {
            initializationError = error
        }
    }
}
