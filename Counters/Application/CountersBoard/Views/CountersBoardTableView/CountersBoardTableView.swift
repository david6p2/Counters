//
//  CountersBoardTableView.swift
//  Counters
//
//  Created by David A Cespedes R on 4/23/21.
//

import UIKit

class CountersBoardTableView: UITableView {

    // MARK: - View Model
    /// The CountersBoard TableView ViewModel
    struct ViewModel {
        /// Counters Array for the Table
        let counters: [CounterModelProtocol]

        var isSearching: Bool

        /// Mock Counter ViewModel to test when there's no data from the server
        static var mockCounters: ViewModel = .init(
            counters: [
                CounterModel(id: "Title1",
                             title: "Apples eaten",
                             count: 0),
                CounterModel(id: "Title2",
                             title: "Number of times I’ve forgotten my mother’s name because I was high on Frugelés.",
                             count: 10)
            ],
            isSearching: false
        )

        /// Empty Counters ViewModel to test the case when there are no counters
        static var empty: ViewModel = .init(counters: [], isSearching: false)
    }

    // MARK: - Properties

    let noResultsLabel = UILabel()
    weak var configureDelegate: CountersBoardTableViewConfigureDelegate?

    // MARK: - Initialization

    init() {
        super.init(frame: .zero, style: .plain    )
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with tableViewModel: ViewModel, animated: Bool) {
        self.register(CountersBoardTableViewCell.self, forCellReuseIdentifier: CountersBoardTableViewCell.reuseIdentifier)
        self.allowsMultipleSelectionDuringEditing = true
        self.allowsSelection = false
        self.separatorStyle = .none
        isHidden = tableViewModel.counters.isEmpty && tableViewModel.isSearching
        noResultsLabel.isHidden = !isHidden && tableViewModel.counters.isEmpty
        configureDelegate?.isCallingConfigureTable(with: tableViewModel, animated: animated)
    }
}

// MARK: - Constants

private extension CountersBoardTableView {
    enum Font {
        static let titleKern: CGFloat = 0.6
        static let title = UIFont.systemFont(ofSize: 20, weight: .regular)
    }
}

// MARK: - Private Implementation

private extension CountersBoardTableView {
    func setup() {
        self.backgroundColor = .background
        self.frame = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
        setupNoResultsLabel()
        setupHierarchy()
        setupConstraints()
    }

    func setupNoResultsLabel() {
        noResultsLabel.font = Font.title
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = .secondaryText
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultsLabel.isHidden = true
    }

    func setupHierarchy() {
        insertSubview(noResultsLabel, aboveSubview: self)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // No Results Label
            noResultsLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            noResultsLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            noResultsLabel.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),

            // TableView
            self.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            self.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
        ])
    }
}
