import UIKit

final class ProductsListView: UIView {
    
    weak var tableViewDataSource: UITableViewDataSource? {
        didSet { tableView.dataSource = tableViewDataSource }
    }
    
    weak var tableViewDelegate: UITableViewDelegate? {
        didSet { tableView.delegate = tableViewDelegate }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.register(TwoColumnTableViewCell.self, forCellReuseIdentifier: TwoColumnTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    private func setupUI() {
        backgroundColor = Colors.backgroundSecondary
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.fillSuperview()
    }
}
