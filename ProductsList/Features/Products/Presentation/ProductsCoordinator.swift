import UIKit

final class ProductsCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let diContainer: DIContainerProtocol
    
    init(navigationController: UINavigationController, diContainer: DIContainerProtocol) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        routeToProductsList()
    }
    
    private func routeToProductsList() {
        let useCase = diContainer.resolve(GetProductSummariesUseCaseProtocol.self)!
        let vc = ProductsListViewController(getProductSummariesUseCase: useCase)
        vc.responder = self
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func routeToProductTransactions() {
        let useCase = diContainer.resolve(GetProductUseCaseProtocol.self)!
        let vc = ProductTransactionsViewController(useCase: useCase)
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - ProductListNavigationResponder

extension ProductsCoordinator: ProductListNavigationResponder {
    
    func navigateToProductDetails() {
        routeToProductTransactions()
    }
}

