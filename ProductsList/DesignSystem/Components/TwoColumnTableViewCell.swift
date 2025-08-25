import UIKit

final class TwoColumnTableViewCell: UITableViewCell {
    
    struct Configuration {
        let primaryText: String
        let secondaryText: String
        let showsDisclosureIndicator: Bool
    }
    
    private lazy var primaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Typography.body
        label.textColor = Colors.textPrimary
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var secondaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Typography.body
        label.textColor = Colors.textSecondary
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [primaryLabel, secondaryLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupSelectionStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with configuration: Configuration) {
        primaryLabel.text = configuration.primaryText
        secondaryLabel.text = configuration.secondaryText
        setupDisclosureIndicator(showsDisclosureIndicator: configuration.showsDisclosureIndicator)
    }
    
    private func setupUI() {
        backgroundColor = Colors.backgroundPrimary
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupSelectionStyle() {
        let selectedView = UIView()
        selectedView.backgroundColor = Colors.backgroundSecondary
        selectedBackgroundView = selectedView
    }
    
    private func setupDisclosureIndicator(showsDisclosureIndicator: Bool) {
        if showsDisclosureIndicator {
            let image = UIImage.chevronAsset
            
            let indicator = UIImageView(image: image)
            indicator.tintColor = Colors.lightGray
            accessoryView = indicator
        } else {
            accessoryView = nil
        }
    }
}

