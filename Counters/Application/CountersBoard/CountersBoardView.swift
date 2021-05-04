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
                                                      doneString: "COUNTERSDASHBOARD_DONE".localized(),
                                                      selectAllString: "COUNTERSDASHBOARD_SELECT_ALL".localized(),
                                                      isEditEnabled: false,
                                                      searchPlaceholder: "COUNTERSDASHBOARD_SEARCHPLACEHOLDER".localized()
        )

        let titleString: String
        let editString: String
        let doneString: String
        let selectAllString: String
        var isEditEnabled: Bool
        let searchPlaceholder: String
    }

    struct ViewModel {
        static var empty: ViewModel = .init(
            parentVM: .init(
                titleString: "",
                editString: "",
                doneString: "",
                selectAllString: "",
                isEditEnabled: false,
                searchPlaceholder: ""
            ),
            isLoading: false,
            noContentVM: .empty,
            countersVM: CountersBoardTableView.ViewModel.empty
        )

        let parentVM: ParentViewModel
        let isLoading: Bool
        let noContentVM: CountersBoardNoContentView.ViewModel
        let countersVM: CountersBoardTableView.ViewModel

        func countersSum() -> String {
            guard countersVM.counters.count > 0 else {
                return ""
            }
            return String(format: "COUNTERSDASHBOARD_COUNTED_ITEMS".localized(),
                          countersVM.counters.count,
                          countersVM.counters.reduce(0, { (result, counter) -> Int in
                            return result + counter.count
                          })
            )
        }

        func getErrorAlertTitle(for errorType: CountersError.ErrorType) -> String {
            switch errorType {
            case .increase(let id):
                let counter = getCounter(for: id)
                return String(format: "COUNTERSDASHBOARD_ERROR_INCREASEDECREASE_TITLE".localized(), counter?.title ?? "", (counter?.count ?? 0) + 1)
            case .decrease(let id):
                let counter = getCounter(for: id)
                return String(format: "COUNTERSDASHBOARD_ERROR_INCREASEDECREASE_TITLE".localized(), counter?.title ?? "", (counter?.count ?? 0) - 1)
            default:
                return ""
            }
        }

        func getCounter(for id: String) -> CounterModelProtocol? {
            return self.countersVM.counters.first{ $0.id == id }
        }
    }

    // MARK: - Properties

    private(set) var viewModel: ViewModel!
    var filteredCounters: [CounterModelProtocol] = []
    private let noContentView = CountersBoardNoContentView()
    private let loadingView = CountersBoardLoadingView()
    private let countersTableView = CountersBoardTableView()
    private let refreshControl = UIRefreshControl()
    private var itemsCountedLabel = UILabel()
    var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    var selectAllButton: UIBarButtonItem!
    var countedItemsBarButtonLabel: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    var trashButton: UIBarButtonItem!
    var shareButton: UIBarButtonItem!
    var addToolbarItems: [UIBarButtonItem]!
    var editToolbarItems: [UIBarButtonItem]!

    var isEditingModeActive = false

    private var dataSource: DataSource!
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

    func configure(withParent parentVM: ParentViewModel) {
        // Navigation Items
        editButton = UIBarButtonItem(
            title: parentVM.editString,
            style: .plain,
            target: self,
            action: #selector(self.edit(sender:))
        )
        editButton.setTitleTextAttributes([.foregroundColor : UIColor.accentColor, .font: Font.edit], for: .normal)
        editButton.setTitleTextAttributes([.foregroundColor: UIColor.disableText, .font: Font.edit], for: .disabled)
        editButton.isEnabled = parentVM.isEditEnabled

        doneButton = UIBarButtonItem(
            title: parentVM.doneString,
            style: .plain,
            target: self,
            action: #selector(self.edit(sender:))
        )
        doneButton.setTitleTextAttributes([.foregroundColor : UIColor.accentColor, .font: Font.done], for: .normal)
        doneButton.setTitleTextAttributes([.foregroundColor: UIColor.disableText, .font: Font.done], for: .disabled)
        doneButton.isEnabled = parentVM.isEditEnabled

        selectAllButton = UIBarButtonItem(
            title: parentVM.selectAllString,
            style: .plain,
            target: self,
            action: #selector(self.selectAll(sender:))
        )
        selectAllButton.setTitleTextAttributes([.foregroundColor : UIColor.accentColor], for: .normal)
        selectAllButton.setTitleTextAttributes([.foregroundColor: UIColor.disableText], for: .disabled)
        selectAllButton.isEnabled = parentVM.isEditEnabled

        // Setup Items Counted Label
        itemsCountedLabel.isHidden = viewModel.countersVM.counters.isEmpty
        itemsCountedLabel.textAlignment = .center
        itemsCountedLabel.attributedText = .init(string: viewModel.countersSum(),
                                                 attributes: [.kern: Font.itemsCountedKern,
                                                              .font: Font.itemsCounted,
                                                              .foregroundColor : UIColor.secondaryText
                                                 ])
        setupToolbars()

        // ToolBar Items
        addButton.isEnabled = !viewModel.isLoading

        // Call View Delegate to configure Navigation Items
        delegate?.setupNavigationControllerWith(title: parentVM.titleString,
                                                editBarButton: isEditingModeActive ? doneButton : editButton,
                                                selectAllBarButton: isEditingModeActive ? selectAllButton : nil,
                                                searchPlaceholder: parentVM.searchPlaceholder,
                                                toolbarItems: isEditingModeActive ? editToolbarItems : addToolbarItems)
    }

    func configure(with viewModel: ViewModel, animated: Bool) {
        self.viewModel = viewModel

        // Configure Parent ViewModel Properties
        configure(withParent: viewModel.parentVM)
        
        // Setup No Content View
        noContentView.configure(with: viewModel.noContentVM)
        noContentView.delegate = self

        // Setup Loading View
        loadingView.configure(with: viewModel.isLoading)
        loadingView.isHidden = !viewModel.isLoading

        // Setup Table View
        countersTableView.configureDelegate = self
        countersTableView.delegate = self
        countersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.endRefreshing()
        countersTableView.configure(with: viewModel.countersVM, animated: animated)
        countersTableView.isHidden = viewModel.isLoading
    }

    func toggleEditing() {
        isEditingModeActive = !isEditingModeActive
        countersTableView.setEditing(isEditingModeActive, animated: true)
        configure(with: viewModel, animated: false)
    }

    func selectAllCounters() {
        let allRows = countersTableView.numberOfRows(inSection: 0)

        for row in 0..<allRows {
            countersTableView.selectRow(
                at: NSIndexPath(row: row, section: 0) as IndexPath,
                animated: false,
                scrollPosition: UITableView.ScrollPosition.none
            )
        }
    }

    func shareSelectedCounters() -> UIActivityViewController? {
        guard let indexPaths = countersTableView.indexPathsForSelectedRows else {
            return nil
        }
        
        let counterItems: [String] = indexPaths.map({ String(format: "COUNTERSDASHBOARD_EDIT_SHARE_TITLE".localized(),
                                                             viewModel.countersVM.counters[$0.row].count,
                                                             viewModel.countersVM.counters[$0.row].title)}
        )

        return UIActivityViewController(activityItems: counterItems, applicationActivities: nil)
    }
}

// MARK: - Actions

private extension CountersBoardView {
    @objc private func edit(sender: UIBarButtonItem) {
        print("Edit button was pressed")
        delegate?.editButtonWasPressed()
    }

    @objc private func selectAll(sender: UIBarButtonItem) {
        print("selectAll button was pressed")
        delegate?.selectAllButtonWasPressed()
    }

    @objc private func add(sender: UIBarButtonItem) {
        print("Add button was pressed")
        delegate?.addButtonWasPressed()
    }

    @objc private func trash(sender: UIBarButtonItem) {
        print("trash button was pressed")
        guard let indexes = self.countersTableView.indexPathsForSelectedRows else {
            return
        }
        let ids = indexes.map({ self.viewModel.countersVM.counters[$0.row].id})
        delegate?.trashButtonWasPressed(withSelectedItemsIds: ids)
    }

    @objc private func share(sender: UIBarButtonItem) {
        print("share button was pressed")
        delegate?.shareButtonWasPressed()
    }

    @objc private func refresh(_ sender: Any) {
        delegate?.pullToRefreshWasCalled()
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
        static let itemsCountedKern: CGFloat = 0.3
        static let itemsCounted = UIFont.systemFont(ofSize: 15, weight: .medium)
        static let title = UIFont.systemFont(ofSize: 33, weight: .heavy)
        static let done = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let edit = UIFont.systemFont(ofSize: 17, weight: .regular)
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

    func setupToolbars() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: self,
                                     action: nil
        )

        countedItemsBarButtonLabel = UIBarButtonItem(customView: itemsCountedLabel)

        addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self,
                                    action: #selector(self.add(sender:))
        )

        trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                      target: self,
                                      action: #selector(self.trash(sender:))
        )

        shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                      target: self,
                                      action: #selector(self.share(sender:))
        )

        addToolbarItems = [spacer, countedItemsBarButtonLabel, spacer, addButton]
        editToolbarItems = [trashButton, spacer, shareButton]
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

// MARK: - DiffableDatasource Subclass

private extension CountersBoardView {
    // Subclassing our data source to supply various UITableViewDataSource methods

    class DataSource: UITableViewDiffableDataSource<CountersBoardView.CounterBoardSection, CounterModel> {

        // MARK: editing support

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }
}

// MARK: - UITableViewDiffableDataSource

extension CountersBoardView {

    enum CounterBoardSection {
        case main
    }

    func configureDataSource() {
        dataSource = DataSource(tableView: countersTableView,
                                cellProvider: { (tableView, indexPath, counter) -> UITableViewCell? in
                                    let cell = tableView.dequeueReusableCell(withIdentifier: CountersBoardTableViewCell.reuseIdentifier,
                                                                             for: indexPath) as! CountersBoardTableViewCell
                                    cell.configure(with: .init(counterModel: counter))
                                    cell.counterCardView.valueDidChange = { [weak self, counter] stepType in
                                        self?.delegate?.cellStepperDidChangeValue(counter,
                                                                                  stepperChangeType: stepType)
                                    }

                                    return cell
                                }
        )
    }

    func updateData(on results: [CounterModel], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<CounterBoardSection, CounterModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(results)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }
}

// MARK: - UITableViewDelegate

extension CountersBoardView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }

        return .none
    }
}

// MARK: - CountersBoardNoContentViewDelegate

extension CountersBoardView: CountersBoardNoContentViewDelegate {
    func noContentButtonPressed(with type: CountersBoardNoContentView.NoContentViewType) {
        delegate?.noContentButtonWasPressed(with: type)
    }
}

// MARK: - CountersBoardTableViewConfigureDelegate

extension CountersBoardView: CountersBoardTableViewConfigureDelegate {
    func isCallingConfigureTable(with viewModel: CountersBoardTableView.ViewModel, animated: Bool) {
        guard let counters = viewModel.counters as? [CounterModel] else {
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
                                       noContentVM: noContentVM,
                                       countersVM: CountersBoardTableView.ViewModel.empty), animated: false
            )
            
            return view
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
