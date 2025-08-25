import UIKit

final class ProductTransactionsView: UIView {
    
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
        tableView.register(TotalHeaderView.self, forHeaderFooterViewReuseIdentifier: TotalHeaderView.reuseIdentifier)
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
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

