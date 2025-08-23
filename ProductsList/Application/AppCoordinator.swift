import UIKit

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        routeToSplashScreen()
    }
    
    private func routeToSplashScreen() {
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
    
    private func routeToProducts() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        let productsCoordinator = ProductsCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(productsCoordinator)
        
        productsCoordinator.start()
    }
}
