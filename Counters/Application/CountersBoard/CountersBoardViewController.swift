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
    var searchController = UISearchController()

    private let presenter: CountersBoardPresenterProtocol

    // MARK: - Initialization
    
    init(presenter: CountersBoardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
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
        presenter.viewDidLoad()
    }

    // MARK: - Configuration

    func setupNavigationBar(_ title: String) {
        guard let navigationController = navigationController else {
            return
        }

        self.title = title
        navigationController.navigationBar.prefersLargeTitles = true
    }

    func setupNavigationBarEditButton(_ editBarButton: UIBarButtonItem) {
        editButton = editBarButton
        navigationItem.leftBarButtonItem = editBarButton
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
    func setup(viewModel: CountersBoardView.ViewModel) {
        innerView.configure(with: viewModel)
    }


}

// MARK: - View Delegate Implementation

extension CountersBoardViewController: CountersBoardViewDelegate {
    func cellStepperDidChangeValue(_ counterID: String, stepperChangeType: CounterCardView.StepperChangeType) {
        switch stepperChangeType {
        case .increase:
            presenter.handelCounterIncrease(counterId: counterID)
        case .decrease:
            presenter.handelCounterDecrease(counterId: counterID)
        }
    }

    func setupNavigationControllerWith(title: String, editBarButton: UIBarButtonItem, searchPlaceholder: String, toolbarItems: [UIBarButtonItem]) {
        setupNavigationBar(title)
        setupNavigationBarEditButton(editBarButton)
        setupSearchController(searchPlaceholder)
        setupToolbar(toolbarItems)
    }
}

// MARK: - UISearchResultsUpdating Protocol Implementation

extension CountersBoardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "No Value")
    }
}

