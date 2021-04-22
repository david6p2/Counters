//
//  CountersBoardViewController.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

class CountersBoardViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    private lazy var innerView = CountersBoardView() // closures de interaccion
    private var editButton: UIBarButtonItem!
    var searchController = UISearchController()

    private let presenter: CountersBoardPresenterProtocol

    init(presenter: CountersBoardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = innerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        innerView.delegate = self
        presenter.viewDidLoad()
    }

    func setupNavigationBar(_ title: String) {
        guard let navigationController = navigationController else {
            return
        }

        navigationController.isNavigationBarHidden = false
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

extension CountersBoardViewController: CountersBoardViewProtocol {
    func setup(viewModel: CountersBoardView.ViewModel) {
        innerView.configure(with: viewModel)
    }


}

extension CountersBoardViewController: CountersBoardViewDelegate {
    func setupNavigationControllerWith(title: String, editBarButton: UIBarButtonItem, searchPlaceholder: String, toolbarItems: [UIBarButtonItem]) {
        setupNavigationBar(title)
        setupNavigationBarEditButton(editBarButton)
        setupSearchController(searchPlaceholder)
        setupToolbar(toolbarItems)
    }
}

extension CountersBoardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "No Value")
    }
}

