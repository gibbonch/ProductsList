import Foundation

final class CurrencyFormatter {
    
    private let numberFormatter: NumberFormatter
    private let locales: [Locale]
    
    private let specialSymbols: [String: String] = [
        "AUD": "A$",
        "CAD": "CA$",
    ]
    
    init() {
        locales = Locale.availableIdentifiers.map(Locale.init)
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
    }
    
    func string(from amount: Amount) -> String {
        let symbol = symbol(for: amount.code)
        let convertedValue = numberFormatter.string(from: NSNumber(value: amount.value)) ?? "\(amount.value)"
        return "\(symbol)\(convertedValue)"
    }
    
    private func symbol(for code: String) -> String {
        if let special = specialSymbols[code] {
            return special
        }
        let locale = locales.first(where: { $0.currencyCode == code })
        return locale?.currencySymbol ?? code
    }
}
