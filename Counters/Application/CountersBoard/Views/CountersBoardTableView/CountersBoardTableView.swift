//
//  CountersBoardTableView.swift
//  Counters
//
//  Created by David A Cespedes R on 4/23/21.
//

import UIKit

class CountersBoardTableView: UIView {

    // MARK: - View Model
    /// The CountersBoard TableView ViewModel
    struct ViewModel {
        /// Counters Array for the Table
        let counterCellsVMs: [CounterCellViewModel]

        let noResultsString: String

        var isSearching: Bool

        /// Mock Counter ViewModel to test when there's no data from the server
        static var mockCounters: ViewModel = .init(
            counterCellsVMs: [
                CounterCellViewModel(counterModel:
                                        CounterModel(id: "Title1",
                                                     title: "Apples eaten",
                                                     count: 0)
                ),
                CounterCellViewModel(counterModel:
                                        CounterModel(id: "Title2",
                                                     title: "Number of times I’ve forgotten my mother’s name because I was high on Frugelés.",
                                                     count: 10))
            ],
            noResultsString: "COUNTERSDASHBOARD_NO_RESULTS_MESSAGE".localized(),
            isSearching: false
        )

        /// Empty Counters ViewModel to test the case when there are no counters
        static var empty: ViewModel = .init(counterCellsVMs: [], noResultsString: "", isSearching: false)
    }

    // MARK: - Properties

    let tableView = UITableView(frame: .zero, style: .plain)
    let noResultsLabel = UILabel()
    weak var configureDelegate: CountersBoardTableViewConfigureDelegate?

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

    func configure(with tableViewModel: ViewModel, animated: Bool) {
        tableView.register(CountersBoardTableViewCell.self, forCellReuseIdentifier: CountersBoardTableViewCell.reuseIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        // Whe need to hide the complete view when there are no counters and we are not searching
        self.isHidden = tableViewModel.counterCellsVMs.isEmpty && !tableViewModel.isSearching

        noResultsLabelShouldBeShown(countersIsEmpty: tableViewModel.counterCellsVMs.isEmpty, isSearching: tableViewModel.isSearching)
        noResultsLabel.attributedText = .init(string: tableViewModel.noResultsString,
                                              attributes: [.kern: Font.titleKern])
        configureDelegate?.isCallingConfigureTable(with: tableViewModel, whileSearching: tableViewModel.isSearching, animated: animated)
    }


    /// No results label should be shown just when there are no counters and we are searching
    /// - Parameters:
    ///   - countersIsEmpty: Are there counters to show?
    ///   - isSearching: is the search bar active
    func noResultsLabelShouldBeShown(countersIsEmpty: Bool, isSearching: Bool) {
        noResultsLabel.isHidden = !(countersIsEmpty && isSearching)
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
        self.translatesAutoresizingMaskIntoConstraints = false
        setupTableView()
        setupNoResultsLabel()
        setupHierarchy()
        setupConstraints()
    }

    func setupTableView() {
        tableView.backgroundColor = .background
        tableView.frame = self.bounds
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupNoResultsLabel() {
        noResultsLabel.font = Font.title
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = .secondaryText
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultsLabel.isHidden = true
    }

    func setupHierarchy() {
        addSubview(tableView)
        addSubview(noResultsLabel)
    }

    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // No Results Label
            noResultsLabel.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor
            ),
            noResultsLabel.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor
            ),
            noResultsLabel.centerYAnchor.constraint(
                equalTo: guide.centerYAnchor
            ),

            // TableView
            tableView.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor
            ),
            tableView.topAnchor.constraint(
                equalTo: guide.topAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: guide.bottomAnchor
            )
        ])
    }
}
