import Foundation

final class TransactionsRepository: TransactionsRepositoryProtocol {
    
    private static let file = "transactions"
    
    private let plistReader: PlistReaderProtocol
    private var cache: [Transaction] = []
    private var initializationError: Error?
    
    init(plistReader: PlistReaderProtocol = PlistReader()) {
        self.plistReader = plistReader
        initializeData()
    }
    
    func fetchAllTransactions() -> Result<[Transaction], any Error> {
        if let initializationError {
            return .failure(initializationError)
        }
        return .success(cache)
    }
    
    func fetchTransactions(with sku: Sku) -> Result<[Transaction], any Error> {
        if let initializationError {
            return .failure(initializationError)
        }
        
        guard cache.map(\.sku).contains(sku) else {
            return .failure(TransactionsRepositoryError.invalidSku)
        }
        
        let filteredTransactions = cache.filter { $0.sku == sku }
        return .success(filteredTransactions)
    }
    
    private func initializeData() {
        do {
            let transactionsDTOs = try plistReader.read(file: Self.file, as: [TransactionDTO].self)
            let transactions = transactionsDTOs.compactMap { dto in
                TransactionMapper.mapToDomain(dto: dto)
            }
            
            self.cache = transactions
            
        } catch {
            initializationError = error
        }
    }
}

enum TransactionsRepositoryError: Error {
    case invalidSku
}
