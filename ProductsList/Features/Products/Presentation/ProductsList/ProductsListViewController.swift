import UIKit

final class ProductsListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TwoColumnTableViewCell.self, forCellReuseIdentifier: TwoColumnTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundSecondary
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}

// MARK: - UITableViewDataSource

extension ProductsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoColumnTableViewCell.reuseIdentifier) as? TwoColumnTableViewCell else {
            return UITableViewCell()
        }
        let config = TwoColumnTableViewCell.Configuration(
            primaryText: "A09292",
            secondaryText: Strings.Products.Summaries.transactions(245),
            showsDisclosureIndicator: true
        )
        cell.configure(with: config)
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
    }

}
