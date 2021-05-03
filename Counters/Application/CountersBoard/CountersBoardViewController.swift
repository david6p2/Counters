//
//  CountersBoardViewController.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

class CountersBoardViewController: UIViewController {

    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private lazy var innerView = CountersBoardView() // closures de interaccion
    private var editButton: UIBarButtonItem!
    private var selectAllButton: UIBarButtonItem?
    var searchController = UISearchController()

    private var presenter: CountersBoardPresenterProtocol

    // MARK: - Initialization
    
    init(presenter: CountersBoardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setPresenterClosures()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = innerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        innerView.delegate = self
        presenter.viewDidLoad(animated: false)
    }

    // MARK: - Configuration

    func setPresenterClosures() {
        presenter.editModeDisableAction = { [weak self] in
            guard let self = self else {
                return
            }

            if self.innerView.isEditingModeActive {
                self.innerView.toggleEditing()
            }
        }
    }

    func setupNavigationBar(_ title: String) {
        self.title = title
    }

    func setupNavigationBarEditButton(_ editBarButton: UIBarButtonItem) {
        editButton = editBarButton
        navigationItem.leftBarButtonItem = editButton
    }

    func setupNavigationBarSelectAllButton(_ selectAllBarButon: UIBarButtonItem?) {
        selectAllButton = selectAllBarButon
        navigationItem.rightBarButtonItem = selectAllButton
    }

    func setupSearchController(_ placeholder: String) {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = placeholder
        searchController.searchBar.tintColor = .accentColor
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
    }

    func setupToolbar(_ toolbarItems: [UIBarButtonItem]) {
        self.toolbarItems = toolbarItems
        navigationController?.setToolbarHidden(false, animated: false)
    }
}

// MARK: - View Protocol Implementation

extension CountersBoardViewController: CountersBoardViewProtocol {
    func setup(viewModel: CountersBoardView.ViewModel, animated: Bool) {
        innerView.configure(with: viewModel, animated: animated)
    }

    func presentAddNewCounter() {
        coordinator?.showAddCounterView()
    }

    func toggleEditing() {
        innerView.toggleEditing()
    }

    func selectAllCounters() {
        innerView.selectAllCounters()
    }

    func shareSelectedCounters() {
        guard let shareViewController = innerView.shareSelectedCounters() else {
            return
        }
        present(shareViewController, animated: true)
    }

    func presentDeleteItemsConfirmationAlert(_ items: [String]) {
        let deleteAlert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertController.Style.actionSheet
        )

        let alertTitleString = items.count > 1 ? "COUNTERSDASHBOARD_EDIT_DELETE_ALERT_TITLE".localized() : "COUNTERSDASHBOARD_EDIT_DELETE_ALERT_TITLE_SINGULAR" .localized()
        
        let deleteAction = UIAlertAction(title: String(format: alertTitleString, items.count) ,
                                         style: .destructive) { (action: UIAlertAction) in
            self.presenter.handleCountersDelete(countersIds: items)
        }

        let cancelAction = UIAlertAction(title: "COUNTERSDASHBOARD_EDIT_DELETE_ALERT_CANCEL".localized(),
                                         style: .cancel,
                                         handler: nil)

        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        self.present(deleteAlert, animated: true, completion: nil)
    }
}

// MARK: - View Delegate Implementation

extension CountersBoardViewController: CountersBoardViewDelegate {
    func setupNavigationControllerWith(title: String,
                                       editBarButton: UIBarButtonItem,
                                       selectAllBarButton: UIBarButtonItem?,
                                       searchPlaceholder: String,
                                       toolbarItems: [UIBarButtonItem]) {
        setupNavigationBar(title)
        setupNavigationBarEditButton(editBarButton)
        setupNavigationBarSelectAllButton(selectAllBarButton)
        setupSearchController(searchPlaceholder)
        setupToolbar(toolbarItems)
    }

    func cellStepperDidChangeValue(_ counter: CounterModelProtocol, stepperChangeType: CounterCardView.StepperChangeType) {
        switch stepperChangeType {
        case .increase:
            presenter.handleCounterIncrease(counter: counter)
        case .decrease:
            presenter.handleCounterDecrease(counter: counter)
        }
    }

    func editButtonWasPressed() {
        presenter.editButtonPressed()
    }

    func selectAllButtonWasPressed() {
        presenter.selectAllPressed()
    }

    func addButtonWasPressed() {
        presenter.addButtonPressed()
    }

    func trashButtonWasPressed(withSelectedItemsIds ids: [String]) {
        presenter.trashButtonWasPressed(withSelectedItemsIds: ids)
    }

    func shareButtonWasPressed() {
        presenter.shareButtonWasPressed()
    }

    func pullToRefreshCalled() {
        presenter.pullToRefreshCalled()
    }
}

// MARK: - UISearchResultsUpdating Protocol Implementation

extension CountersBoardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "No Value")
    }
}

