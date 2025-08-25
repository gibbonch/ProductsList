import UIKit
import Combine

final class ProductTransactionsViewController: UIViewController {
    
    private let viewModel: ProductTransactionsViewModelProtocol
    private var transactions: [TransactionUIModel] = []
    private var total: String = ""
    
    private lazy var productTransactionsView: ProductTransactionsView = {
        let view = ProductTransactionsView()
        view.tableViewDataSource = self
        view.tableViewDelegate = self
        return view
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: ProductTransactionsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        view = productTransactionsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewLoaded()
    }
    
    private func bindViewModel() {
        title = viewModel.title
        
        viewModel.product.sink { [weak self] product in
            self?.transactions = product.transactions
            self?.total = product.total
            self?.productTransactionsView.reloadData()
        }.store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource

extension ProductTransactionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoColumnTableViewCell.reuseIdentifier) as? TwoColumnTableViewCell else {
            return UITableViewCell()
        }
        let transaction = transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TotalHeaderView.reuseIdentifier) as? TotalHeaderView
        view?.setTotal(total)
        return view
    }
}

// MARK: - UITableViewDelegate

extension ProductTransactionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}

// MARK: - Typealias

typealias TransactionUIModel = TwoColumnTableViewCell.Configuration

