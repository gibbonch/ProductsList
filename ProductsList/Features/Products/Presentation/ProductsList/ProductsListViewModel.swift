import Foundation
import Combine

protocol ProductsListViewModelProtocol {
    var title: String { get }
    var summaries: AnyPublisher<[ProductSummaryUIModel], Never> { get }
    func viewLoaded()
    func cellSelected(at indexPath: IndexPath)
}

final class ProductsListViewModel: ProductsListViewModelProtocol {
    
    weak var responder: ProductListNavigationResponder?
    
    let title = Strings.Products.Summaries.title
    
    var summaries: AnyPublisher<[ProductSummaryUIModel], Never> {
        summariesSubject
            .map { summaries in
                summaries.map { summary in
                    ProductSummaryUIModel(
                        primaryText: summary.sku,
                        secondaryText: Strings.Products.Summaries.transactions(summary.count),
                        showsDisclosureIndicator: true
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private let summariesSubject = CurrentValueSubject<[ProductSummary], Never>([])
    private let useCase: GetProductSummariesUseCaseProtocol
    
    init(useCase: GetProductSummariesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func viewLoaded() {
        useCase.execute { [weak self] result in
            switch result {
            case .success(let summaries):
                self?.summariesSubject.send(summaries)
            case .failure(_):
                self?.summariesSubject.send([])
            }
        }
    }
    
    func cellSelected(at indexPath: IndexPath) {
        let sku = summariesSubject.value[indexPath.row].sku
        responder?.navigateToProductDetails(with: sku)
    }
}
