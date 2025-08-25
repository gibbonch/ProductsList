import UIKit

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let diContainer: DIContainerProtocol
    private var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow, diContainer: DIContainerProtocol) {
        self.window = window
        self.diContainer = diContainer
    }
    
    func start() {
        routeToSplashScreen()
        
        let productsDIContainer = DIContainer()
        productsDIContainer.parent = diContainer
        ProductsAssembly.assemble(diContainer: productsDIContainer) { [weak self] in
            self?.routeToProducts(diContainer: productsDIContainer)
        }
    }
    
    private func routeToSplashScreen() {
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
    
    private func routeToProducts(diContainer: DIContainerProtocol) {
        setupNavigationBar()
        let navigationController = UINavigationController()
        
        let productsCoordinator = ProductsCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        childCoordinators.append(productsCoordinator)
        productsCoordinator.start()
        
        window.rootViewController = navigationController
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.backgroundSecondary
        
        appearance.titleTextAttributes = [
            .foregroundColor: Colors.textPrimary,
            .font: Typography.title
        ]
        
        appearance.shadowColor = Colors.gray
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
    
}
