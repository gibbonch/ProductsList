import UIKit

final class SplashView: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = Strings.Splash.title
        label.font = Typography.largeTitle
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = Colors.backgroundPrimary
        addSubview(label)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
