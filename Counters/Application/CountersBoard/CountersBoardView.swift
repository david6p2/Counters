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
        // Navigation Items
        // TODO: Take title from ViewModel
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

        // TODO: Check States
        // Setup No Content View
        noContentView.configure(with: viewModel.noCounters)
        noContentView.delegate = self
    }

    @objc private func edit(sender: UIBarButtonItem) {

    }
}

// MARK: - Private Constants

private extension CountersBoardView {
    enum Constants {
        static let spacing: CGFloat = 24
        static let buttonHeight: CGFloat = 57
    }

    enum Font {
        static let kern: CGFloat = 0.34
        static let title = UIFont.systemFont(ofSize: 33, weight: .heavy)
        static let description = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
}

// MARK: - Private Implementation

private extension CountersBoardView {
    func setup() {
        backgroundColor = .systemBackground
        setupViewHierarchy()
        setupConstraints()
    }

    func setupViewHierarchy() {
        addSubview(noContentView)
    }

    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            noContentView.topAnchor.constraint(
                equalTo: guide.topAnchor
            ),
            noContentView.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor
            ),
            noContentView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor
            ),
            noContentView.bottomAnchor.constraint(
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
