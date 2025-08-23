import UIKit

final class AppCoordinator: CoordinatorProtocol {
    
    // MARK: - Private Properties
    
    private let navigationController: UINavigationController
//    private var diContainer: DIContainer?
    
    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal Methods
    
    func start() {
        routeToProductsList()
    }
    
    // MARK: - Private Methods
    
    private func routeToProductsList() {
        let vc = ProductsListViewController()
        vc.responder = self
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func routeToProductTransactions() {
        let vc = ProductTransactionsViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - ProductListNavigationResponder

extension AppCoordinator: ProductListNavigationResponder {
    
    func navigateToProductDetails() {
        routeToProductTransactions()
    }
}
