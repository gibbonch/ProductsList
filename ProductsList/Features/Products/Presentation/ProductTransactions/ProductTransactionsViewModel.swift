import Foundation
import Combine

protocol ProductTransactionsViewModelProtocol {
    var title: String { get }
    var product: AnyPublisher<ProductUIModel, Never> { get }
    func viewLoaded()
}

final class ProductTransactionsViewModel: ProductTransactionsViewModelProtocol {
    
    lazy var title: String = {
        Strings.Products.Transactions.title(for: sku)
    }()
    
    var product: AnyPublisher<ProductUIModel, Never> {
        productSubject
            .compactMap { [weak self] product in
                guard let self else { return nil }
                return mapToUIModel(product: product)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private let productSubject = PassthroughSubject<Product, Never>()
    private let sku: Sku
    private let useCase: GetProductUseCaseProtocol
    private let formatter: CurrencyFormatter
    
    init(sku: Sku, useCase: GetProductUseCaseProtocol, formatter: CurrencyFormatter = CurrencyFormatter()) {
        self.sku = sku
        self.useCase = useCase
        self.formatter = formatter
    }
    
    func viewLoaded() {
        useCase.execute(with: sku) { result in
            switch result {
            case .success(let product):
                self.productSubject.send(product)
            case .failure:
                break
            }
        }
    }
    
    private func mapToUIModel(product: Product) -> ProductUIModel {
        let totalAmount = product.totalAmount
        let convertedTotalAmount = formatter.string(from: totalAmount)
        let total = Strings.Products.Transactions.total(convertedTotalAmount)
        
        let transactions = product.conversions.map { conversion in
            let fromAmount = conversion.transaction.amount
            let convertedFromAmount = self.formatter.string(from: fromAmount)
            let toAmount = conversion.convertedAmount
            let convertedToAmount = self.formatter.string(from: toAmount)
            return TransactionUIModel(
                primaryText: convertedFromAmount,
                secondaryText: convertedToAmount,
                showsDisclosureIndicator: false
            )
        }
        return ProductUIModel(total: total, transactions: transactions)
    }
}

