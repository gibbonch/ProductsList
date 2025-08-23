import Foundation

final class ProductsAssembly {
    
    static func assemble(diContainer: DIContainerProtocol, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            diContainer.register(for: TransactionsRepositoryProtocol.self, TransactionsRepository())
            diContainer.register(for: CurrencyRatesRepositoryProtocol.self, CurrencyRatesRepository())
            
            diContainer.register(for: GetProductSummariesUseCaseProtocol.self) { diContainer in
                let transactionsRepository = diContainer.resolve(TransactionsRepositoryProtocol.self)!
                return GetProductSummariesUseCase(repository: transactionsRepository)
            }
            
            diContainer.register(for: GetProductUseCaseProtocol.self) { diContainer in
                let transactionsRepository = diContainer.resolve(TransactionsRepositoryProtocol.self)!
                let currencyRatesRepository = diContainer.resolve(CurrencyRatesRepositoryProtocol.self)!
                return GetProductUseCase(
                    transactionsRepository: transactionsRepository,
                    currencyRatesRepository: currencyRatesRepository
                )
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
