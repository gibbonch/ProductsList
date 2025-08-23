import Foundation

protocol GetProductSummariesUseCaseProtocol {
    func execute(completion: @escaping (Result<[ProductSummary], Error>) -> Void)
}

final class GetProductSummariesUseCase: GetProductSummariesUseCaseProtocol {
    
    private let repository: TransactionsRepositoryProtocol
    
    init(repository: TransactionsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[ProductSummary], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let result = repository.fetchAllTransactions()
            
            switch result {
            case .success(let transactions):
                let summaries = mapToProductSummaries(transactions)
                completion(.success(summaries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    private func mapToProductSummaries(_ transactions: [Transaction]) -> [ProductSummary] {
        Dictionary(grouping: transactions, by: { $0.sku })
            .map { sku, transactions in
                ProductSummary(sku: sku, count: transactions.count)
            }
            .sorted { $0.sku < $1.sku }
    }
}
