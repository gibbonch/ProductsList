import UIKit

final class ProductsCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        routeToProductsList()
    }
    
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

extension ProductsCoordinator: ProductListNavigationResponder {
    
    func navigateToProductDetails() {
        routeToProductTransactions()
    }
}

