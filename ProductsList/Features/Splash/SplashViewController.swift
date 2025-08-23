import UIKit

final class SplashViewController: UIViewController {
    
    private lazy var splashView = SplashView()
    
    override func loadView() {
        view = splashView
    }
}
