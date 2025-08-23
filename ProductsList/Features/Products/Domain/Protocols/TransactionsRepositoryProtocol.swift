protocol TransactionsRepositoryProtocol {
    func fetchAllTransactions() -> Result<[Transaction], Error>
    func fetchTransactions(with sku: Sku) -> Result<[Transaction], Error>
}


