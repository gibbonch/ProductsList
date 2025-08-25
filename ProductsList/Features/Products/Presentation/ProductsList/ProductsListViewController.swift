import UIKit
import Combine

final class ProductsListViewController: UIViewController {
    
    private let viewModel: ProductsListViewModelProtocol
    private var summaries: [ProductSummaryUIModel] = []
    
    private lazy var productsListView: ProductsListView = {
        let view = ProductsListView()
        view.tableViewDataSource = self
        view.tableViewDelegate = self
        return view
    }()
    
    private var cancellables: Set<AnyCancellable> = []
        
    init(viewModel: ProductsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        view = productsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bindViewModel()
        viewModel.viewLoaded()
    }
    
    private func setupNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.tintColor = Colors.accentBlue
    }
    
    private func bindViewModel() {
        viewModel.summaries.sink { [weak self] summaries in
            self?.summaries = summaries
            self?.productsListView.reloadData()
        }.store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource

extension ProductsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        summaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoColumnTableViewCell.reuseIdentifier) as? TwoColumnTableViewCell else {
            return UITableViewCell()
        }
        let summary = summaries[indexPath.row]
        cell.configure(with: summary)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProductsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.cellSelected(at: indexPath)
    }
}

// MARK: - Typealias

typealias ProductSummaryUIModel = TwoColumnTableViewCell.Configuration
