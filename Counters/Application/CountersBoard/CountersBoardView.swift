//
//  CountersBoardView.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import Foundation

import UIKit

internal final class CountersBoardView: UIView {
    // MARK: - View Model

    struct ViewModel {
        let title: String
        let noCounters: CountersBoardNoContentView.ViewModel
    }

    // MARK: - Properties

    private let stackView = UIStackView()
    private let noContentView = CountersBoardNoContentView()
    private let countersTableView = UITableView()
    private let additionToolBar = UIToolbar()
    private let itemsCountedLabel = UILabel()

    private var editButton: UIBarButtonItem!

    weak var delegate: CountersBoardViewDelegate?

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
        //super.title = viewModel.title

        // Navigation Items
        editButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(self.edit(sender:))
        )
        editButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], for: .normal)

        // Toolbar Items
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let toolbarItems = [spacer, add]
        
        delegate?.setupNavigationControllerWith(title: viewModel.title, editBarButton: editButton, toolbarItems: toolbarItems)

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // TODO: Check States
        // Setup No Content View
        noContentView.configure(with: viewModel.noCounters)
        noContentView.delegate = self
        stackView.addArrangedSubview(noContentView)


    }

    @objc private func edit(sender: UIBarButtonItem) {

    }
}

// MARK: - Private Constants

private extension CountersBoardView {
    enum Constants {
        static let spacing: CGFloat = 24
        static let buttonHeight: CGFloat = 57
        static let stackViewTopMargin: CGFloat = 45
    }

    enum Font {
        static let kern: CGFloat = 0.34
        static let title = UIFont.systemFont(ofSize: 33, weight: .heavy)
        static let description = UIFont.systemFont(ofSize: 17, weight: .regular)
    }

    enum Shadow {
        static let opacity: Float = 1
        static let radius: CGFloat = 16
        static let offset = CGSize(width: 0, height: 8)
        static let color = UIColor(white: 0, alpha: 0.1).cgColor
    }
}

// MARK: - Private Implementation

private extension CountersBoardView {
    func setup() {
        backgroundColor = .systemBackground
        setupStackView()
        setupViewHierarchy()
        setupConstraints()
    }

    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.alignment = .top
    }

    func setupViewHierarchy() {
        addSubview(stackView)
    }

    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // stack view
            stackView.topAnchor.constraint(
                equalTo: guide.topAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo: guide.bottomAnchor
            )
        ])
    }
}

extension CountersBoardView: CountersBoardNoContentViewDelegate {
    func noContentButtonsPressed() {
        print("Button Pressed")
    }
}
