import Foundation

struct TransactionDTO: Decodable {
    let amount: String
    let currency: String
    let sku: String
}
