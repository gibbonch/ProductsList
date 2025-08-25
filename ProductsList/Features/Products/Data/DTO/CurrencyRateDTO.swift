import Foundation

struct CurrencyRateDTO: Decodable {
    let from: String
    let to: String
    let rate: String
}

enum CurrencyRateMapper {
    
    static func mapToDomain(dto: CurrencyRateDTO) -> CurrencyRate? {
        guard let multiplier = Multiplier(dto.rate),
              multiplier >= 0,
              NSLocale.isoCurrencyCodes.contains(dto.from),
              NSLocale.isoCurrencyCodes.contains(dto.to) else {
            return nil
        }
        
        return CurrencyRate(
            fromCurrency: dto.from,
            toCurrency: dto.to,
            multiplier: multiplier
        )
    }
}
