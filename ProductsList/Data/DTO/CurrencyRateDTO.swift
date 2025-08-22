import Foundation

struct CurrencyRateDTO: Decodable {
    let from: String
    let to: String
    let rate: String
}
