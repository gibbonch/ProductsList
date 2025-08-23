import Foundation

final class AppAssembly {
    
    static func assemble(diContainer: DIContainerProtocol) {
        diContainer.register(for: CurrencyConverterProtocol.self, CurrencyConverter())
        diContainer.register(for: PlistReaderProtocol.self) {
            PlistReader()
        }
    }
}
