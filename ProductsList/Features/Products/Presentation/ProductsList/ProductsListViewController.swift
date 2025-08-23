import UIKit

final class ProductsListViewController: UIViewController {
    
    weak var responder: ProductListNavigationResponder?
    private let getProductSummariesUseCase: GetProductSummariesUseCaseProtocol
    
    init(getProductSummariesUseCase: GetProductSummariesUseCaseProtocol) {
        self.getProductSummariesUseCase = getProductSummariesUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
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
        
        getProductSummariesUseCase.execute { result in
            switch result {
            case .success(let summaries):
                print(summaries)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func navigate() {
        responder?.navigateToProductDetails()
    }
}
