import Foundation

final class CurrencyRatesRepository: CurrencyRatesRepositoryProtocol {
    
    private static let file = "rates"
    
    private let plistReader: PlistReaderProtocol
    private var cache: [CurrencyRate] = []
    private var initializationError: Error?
    
    init(plistReader: PlistReaderProtocol = PlistReader()) {
        self.plistReader = plistReader
        initializeData()
    }
    
    func fetchCurrencyRates() -> Result<[CurrencyRate], Error> {
        if let initializationError {
            return .failure(initializationError)
        }
        return .success(cache)
    }
    
    private func initializeData() {
        do {
            let rateDTOs = try plistReader.read(file: Self.file, as: [CurrencyRateDTO].self)
            let rates = rateDTOs.compactMap { dto in
                CurrencyRateMapper.mapToDomain(dto: dto)
            }
            
            self.cache = rates
            
        } catch {
            initializationError = error
        }
    }
}
