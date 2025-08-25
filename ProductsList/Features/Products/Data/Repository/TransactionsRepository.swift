import Foundation

final class TransactionsRepository: TransactionsRepositoryProtocol {
    
    private static let file = "transactions"
    
    private let plistReader: PlistReaderProtocol
    private var transactions: [Transaction] = []
    private var initializationError: Error?
    
    init(plistReader: PlistReaderProtocol = PlistReader()) {
        self.plistReader = plistReader
        loadTransactions()
    }
    
    func fetchAllTransactions() -> Result<[Transaction], any Error> {
        if let initializationError {
            return .failure(initializationError)
        }
        return .success(transactions)
    }
    
    func fetchTransactions(with sku: Sku) -> Result<[Transaction], any Error> {
        if let initializationError {
            return .failure(initializationError)
        }
        
        guard transactions.map(\.sku).contains(sku) else {
            return .failure(TransactionsRepositoryError.invalidSku)
        }
        
        let filteredTransactions = transactions.filter { $0.sku == sku }
        return .success(filteredTransactions)
    }
    
    private func loadTransactions() {
        do {
            let transactionsDTOs = try plistReader.read(file: Self.file, as: [TransactionDTO].self)
            let mappedTransactions = transactionsDTOs.compactMap { dto in
                TransactionMapper.mapToDomain(dto: dto)
            }
            
            self.transactions = mappedTransactions
            
        } catch {
            initializationError = error
        }
    }
}

enum TransactionsRepositoryError: Error {
    case invalidSku
}
