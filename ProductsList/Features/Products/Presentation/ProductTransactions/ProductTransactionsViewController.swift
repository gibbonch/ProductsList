import UIKit

final class ProductTransactionsViewController: UIViewController {
    //"A0911"
    let useCase: GetProductUseCaseProtocol
    
    init(useCase: GetProductUseCaseProtocol) {
        self.useCase = useCase
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        useCase.execute(with: "A0911") { result in
            switch result {
                
            case .success(let product):
                print(product)
            case .failure(let error):
                print(error)
            }
        }
    }
}
