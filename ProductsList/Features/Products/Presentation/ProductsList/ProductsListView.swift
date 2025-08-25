import UIKit

final class ProductsListView: UIView {
    
    weak var tableViewDataSource: UITableViewDataSource? {
        didSet { tableView.dataSource = tableViewDataSource }
    }
    
    weak var tableViewDelegate: UITableViewDelegate? {
        didSet { tableView.delegate = tableViewDelegate }
    }
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.register(TwoColumnTableViewCell.self, forCellReuseIdentifier: TwoColumnTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    private func setupUI() {
        backgroundColor = Colors.backgroundSecondary
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}
