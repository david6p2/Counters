//
//  CountersBoardNoContentView.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

class CountersBoardNoContentView: UIView {

    // MARK: - View Model

    struct ViewModel: Hashable {
        let title: String
        let subtitle: String
        let buttonTitle: String
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = Button()
    private let stackView = UIStackView()

    weak var delegate: CountersBoardNoContentViewDelegate?

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with viewModel: ViewModel) {
        titleLabel.attributedText = .init(string: viewModel.title, attributes: [.kern: Font.kern])
        subtitleLabel.attributedText = .init(string: viewModel.subtitle, attributes: [.kern: Font.kern])
        actionButton.setTitle(viewModel.buttonTitle, for: .normal)
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubviews(titleLabel, subtitleLabel, actionButton)
    }
}
// MARK: - Constants

private extension CountersBoardNoContentView {
    enum Constants {
        static let spacing: CGFloat = 20
        static let imageWidth: CGFloat = 49
        static let horizontalSpacing: CGFloat = 15
        static let verticalSpacing: CGFloat = 7
        static let stackViewTopMargin: CGFloat = 45
        static let stackViewSideMargin: CGFloat = 20
    }

    enum Font {
        static let kern: CGFloat = 0.34
        static let title = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let subtitle = UIFont.systemFont(ofSize: 17, weight: .regular)
    }

    enum Shadow {
        static let opacity: Float = 1
        static let radius: CGFloat = 16
        static let offset = CGSize(width: 0, height: 8)
        static let color = UIColor(white: 0, alpha: 0.1).cgColor
    }
}

// MARK: - Private Implementation

private extension CountersBoardNoContentView {
    func setup() {
        self.backgroundColor = .background
        self.frame = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
        setupTitleLabel()
        setupSubtitleLabel()
        setupButton()
        setupStackView()
        setupHierarchy()
        setupConstraints()
    }

    func setupTitleLabel() {
        titleLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: Font.title)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupSubtitleLabel() {
        subtitleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.subtitle)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor(named: "DescriptionText")
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(didPressActionButton), for: .touchUpInside)

        actionButton.layer.cornerRadius = 8
        actionButton.clipsToBounds = false
        actionButton.layer.shadowRadius = Shadow.radius
        actionButton.layer.shadowColor = Shadow.color
        actionButton.layer.shadowOffset = Shadow.offset
        actionButton.layer.shadowOpacity = Shadow.opacity
    }

    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.alignment = .center
    }

    func setupHierarchy() {
        addSubview(stackView)
    }

    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([

            stackView.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor
            ),
            stackView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
        ])
    }
}

private extension CountersBoardNoContentView {
    @objc func didPressActionButton() {
        delegate?.noContentButtonsPressed()
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CountersDashboardNoContent_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreviewContainer { _ in
            let view = CountersBoardNoContentView()
            view.configure(with: CountersBoardViewPresenter.init().viewModel.noCounters)
            return view
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
