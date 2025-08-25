import Foundation

protocol GetProductUseCaseProtocol {
    func execute(with sku: Sku, completion: @escaping (Result<Product, Error>) -> Void)
}

final class GetProductUseCase: GetProductUseCaseProtocol {
    
    private let transactionsRepository: TransactionsRepositoryProtocol
    private let currencyRatesRepository: CurrencyRatesRepositoryProtocol
    private let currencyConverter: CurrencyConverterProtocol
    
    private let targetCurrency: CurrencyCode = CurrencyEnvironment.base.rawValue
    
    init(
        transactionsRepository: TransactionsRepositoryProtocol,
        currencyRatesRepository: CurrencyRatesRepositoryProtocol,
        currencyConverter: CurrencyConverterProtocol = CurrencyConverter()
    ) {
        self.transactionsRepository = transactionsRepository
        self.currencyRatesRepository = currencyRatesRepository
        self.currencyConverter = currencyConverter
    }
    
    func execute(with sku: Sku, completion: @escaping (Result<Product, any Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            
            switch currencyRatesRepository.fetchCurrencyRates() {
            case .success(let rates):
                currencyConverter.loadRates(rates)
            case .failure(let error):
                completion(.failure(error))
                return
            }
            
            switch transactionsRepository.fetchTransactions(with: sku) {
            case .success(let transactions):
                let conversions = convertTransactions(transactions)
                let totalAmount = calculateTotalAmount(from: conversions)
                let product = Product(sku: sku, conversions: conversions, totalAmount: totalAmount)
                completion(.success(product))
                
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    private func convertTransactions(_ transactions: [Transaction]) -> [CurrencyConversion] {
        var conversions: [CurrencyConversion] = []
        for transaction in transactions {
            if let convertedAmount = try? currencyConverter.convert(from: transaction.amount, to: targetCurrency) {
                let conversion = CurrencyConversion(transaction: transaction, convertedAmount: convertedAmount)
                conversions.append(conversion)
            }
        }
        return conversions
    }
    
    private func calculateTotalAmount(from conversions: [CurrencyConversion]) -> Amount {
        let totalValue = conversions.reduce(0.0) { $0 + $1.convertedAmount.value }
        return Amount(value: totalValue, code: targetCurrency)
    }
}
