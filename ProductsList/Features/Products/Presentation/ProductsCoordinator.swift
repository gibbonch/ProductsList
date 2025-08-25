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
        let viewModel = ProductsListViewModel(useCase: useCase)
        viewModel.responder = self
        let viewController = ProductsListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func routeToProductTransactions(with sku: Sku) {
        let useCase = diContainer.resolve(GetProductUseCaseProtocol.self)!
        let viewModel = ProductTransactionsViewModel(sku: sku, useCase: useCase)
        let viewController = ProductTransactionsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - ProductListNavigationResponder

extension ProductsCoordinator: ProductListNavigationResponder {
    
    func navigateToProductDetails(with sku: Sku) {
        routeToProductTransactions(with: sku)
    }
}

