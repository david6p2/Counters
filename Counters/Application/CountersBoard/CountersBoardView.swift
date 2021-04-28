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

    struct ParentViewModel {
        static let defaultVM: ParentViewModel = .init(titleString: "COUNTERSDASHBOARD_TITLE".localized(),
                                                            editString: "COUNTERSDASHBOARD_EDIT".localized(),
                                                            isEditEnabled: false,
                                                            searchPlaceholder: "COUNTERSDASHBOARD_SEARCHPLACEHOLDER".localized()
        )

        let titleString: String
        let editString: String
        var isEditEnabled: Bool
        let searchPlaceholder: String
    }

    struct ViewModel {
        static var empty: ViewModel = .init(
            parentVM: .init(
                titleString: "",
                editString: "",
                isEditEnabled: false,
                searchPlaceholder: ""
            ),
            isLoading: false,
            noContent: .empty,
            counters: CountersBoardTableView.ViewModel.empty.counters
        )

        let parentVM: ParentViewModel
        let isLoading: Bool
        let noContent: CountersBoardNoContentView.ViewModel
        let counters: [CounterModelProtocol]
    }

    // MARK: - Properties

    private let noContentView = CountersBoardNoContentView()
    private let loadingView = CountersBoardLoadingView()
    private let countersTableView = CountersBoardTableView()
    private let refreshControl = UIRefreshControl()
    private let itemsCountedLabel = UILabel()
    var editButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!

    var dataSource: UITableViewDiffableDataSource<Section, CounterModel>!
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

    func configure(with viewModel: ViewModel, animated: Bool) {
        // Navigation Items
        editButton = UIBarButtonItem(
            title: viewModel.parentVM.editString,
            style: .plain,
            target: self,
            action: #selector(self.edit(sender:))
        )
        editButton.setTitleTextAttributes([.foregroundColor : UIColor.accentColor], for: .normal)
        editButton.setTitleTextAttributes([.foregroundColor: UIColor.disableText], for: .disabled)
        editButton.isEnabled = viewModel.parentVM.isEditEnabled

        // Toolbar Items
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: self,
                                     action: nil
        )
        
        let add = UIBarButtonItem(barButtonSystemItem: .add,
                                  target: self,
                                  action: #selector(self.add(sender:))
        )

        let toolbarItems = [spacer, add]
        addButton = add

        // Call View Delegate to configure Navigation Items
        delegate?.setupNavigationControllerWith(title: viewModel.parentVM.titleString, editBarButton: editButton, searchPlaceholder: viewModel.parentVM.searchPlaceholder, toolbarItems: toolbarItems)

        // Setup No Content View
        noContentView.configure(with: viewModel.noContent)
        noContentView.delegate = self

        // Setup Loading View
        loadingView.configure(with: viewModel.isLoading)
        loadingView.isHidden = !viewModel.isLoading

        // Setup Table View
        countersTableView.configureDelegate = self
        countersTableView.separatorStyle = .none
        countersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.endRefreshing()
        countersTableView.configure(with: viewModel.counters, animated: true)
    }
}

// MARK: - Actions

private extension CountersBoardView {
    @objc private func edit(sender: UIBarButtonItem) {
        print("Edit button was pressed")
        delegate?.editButtonWasPressed()
    }

    @objc private func add(sender: UIBarButtonItem) {
        print("Add button was pressed")
        delegate?.addButtonWasPressed()
    }

    @objc private func refresh(_ sender: Any) {
        delegate?.pullToRefreshCalled()
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
        configureDataSource()
        setupViewHierarchy()
        setupConstraints()
    }

    func setupViewHierarchy() {
        addSubview(noContentView)
        addSubview(loadingView)
        addSubview(countersTableView)
    }

    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // noContentView
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
            ),

            // loadingView
            loadingView.topAnchor.constraint(
                equalTo: guide.topAnchor
            ),
            loadingView.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor
            ),
            loadingView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor
            ),
            loadingView.bottomAnchor.constraint(
                equalTo: guide.bottomAnchor
            ),

            // countersTableView
            guide.topAnchor.constraint(
                equalTo: countersTableView.topAnchor
            ),
            countersTableView.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor
            ),
            countersTableView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor
            ),
            countersTableView.bottomAnchor.constraint(
                equalTo: guide.bottomAnchor
            )

        ])
    }
}

// MARK: - UITableViewDiffableDataSource
extension CountersBoardView {

    enum Section {
        case main
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, CounterModel>(
            tableView: countersTableView,
            cellProvider: { (tableView, indexPath, counter) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: CountersBoardTableViewCell.reuseIdentifier,
                                                         for: indexPath) as! CountersBoardTableViewCell
                cell.configure(with: .init(counterModel: counter))
                cell.counterCardView.valueDidChange = { [weak self, counter] stepType in
                    self?.delegate?.cellStepperDidChangeValue(counter.id,
                                                             stepperChangeType: stepType)
                }

                return cell
            }
        )
    }

    func updateData(on results: [CounterModel], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CounterModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(results)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }
}

// MARK: - CountersBoardNoContentViewDelegate

extension CountersBoardView: CountersBoardNoContentViewDelegate {
    func noContentButtonsPressed() {
        print("Button Pressed to notify presenter")
    }
}

// MARK: - CountersBoardTableViewConfigureDelegate

extension CountersBoardView: CountersBoardTableViewConfigureDelegate {
    func isCallingConfigure(with counters: [CounterModelProtocol], animated: Bool) {
        guard let counters = counters as? [CounterModel] else {
            updateData(on: [], animated: animated)
            return
        }

        updateData(on: counters, animated: animated)
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CountersDashboard_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreviewContainer { _ in
            let view = CountersBoardView()

            let noContentVM: CountersBoardNoContentView.ViewModel = .init(title: "COUNTERSDASHBOARD_ERROR_TITLE".localized(),
                                                                          subtitle: "COUNTERSDASHBOARD_ERROR_SUBTITLE".localized(),
                                                                          buttonTitle: "COUNTERSDASHBOARD_ERROR_BUTTONTITLE".localized(),
                                                                          isHidden: false
            )

            view.configure(with: .init(parentVM: CountersBoardView.ParentViewModel.defaultVM,
                                       isLoading: false,
                                       noContent: noContentVM,
                                       counters: CountersBoardTableView.ViewModel.empty.counters), animated: false
            )
            
            return view
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
