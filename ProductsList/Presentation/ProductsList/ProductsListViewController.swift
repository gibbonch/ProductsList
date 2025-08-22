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
//        responder?.navigateToProductDetails()
        
        let startTime = CFAbsoluteTimeGetCurrent()

        let reader = PlistReader()
        let transactions: [TransactionDTO] = (try? reader.read(file: "transaction")) ?? []
        print(transactions)
        print(transactions.count)

        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("⏱️ Time elapsed: \(timeElapsed * 1000) ms")
    }
}
