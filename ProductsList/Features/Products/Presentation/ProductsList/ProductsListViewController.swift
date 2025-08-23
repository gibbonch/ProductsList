import UIKit

final class ProductsListViewController: UIViewController {
    
    weak var responder: ProductListNavigationResponder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(navigate), for: .touchUpInside)
        button.setTitle("navigate", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func navigate() {
        
    }
}
