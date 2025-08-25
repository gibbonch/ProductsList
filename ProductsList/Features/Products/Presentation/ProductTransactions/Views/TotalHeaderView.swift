import UIKit

final class TotalHeaderView: UITableViewHeaderFooterView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Typography.title
        label.textColor = Colors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    func setTotal(_ total: String) {
        label.text = total
    }
    
    private func setupUI() {
        backgroundColor = Colors.backgroundSecondary
        addSubview(label)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
}
