@testable import ProductsList

final class MockTransactionsRepository: TransactionsRepositoryProtocol {
    
    var mockTransactions: [Transaction] = []
    var mockError: Error?
    
    var fetchAllTransactionsCallCount = 0
    var fetchTransactionsCallCount = 0
    var capturedSku: Sku?
    
    func fetchAllTransactions() -> Result<[Transaction], any Error> {
        fetchAllTransactionsCallCount += 1
        
        if let mockError {
            return .failure(mockError)
        }
        return .success(mockTransactions)
    }
    
    func fetchTransactions(with sku: Sku) -> Result<[Transaction], any Error> {
        fetchTransactionsCallCount += 1
        capturedSku = sku
        
        if let mockError {
            return .failure(mockError)
        }
        
        let filteredTransactions = mockTransactions.filter { $0.sku == sku }
        return .success(filteredTransactions)
    }
}
