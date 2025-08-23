import Foundation

struct TransactionDTO: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

enum TransactionMapper {
    
    static func mapToDomain(dto: TransactionDTO) -> Transaction? {
        guard let value = Multiplier(dto.amount),
              NSLocale.isoCurrencyCodes.contains(dto.currency) else {
            return nil
        }
        return Transaction(
            sku: dto.sku,
            amount: Amount(value: value, code: dto.currency)
        )
    }
}
