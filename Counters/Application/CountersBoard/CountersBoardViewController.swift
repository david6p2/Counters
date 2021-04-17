//
//  CountersBoardViewController.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

protocol CountersBoardViewControllerPresenter {
    var viewModel: CountersBoardView.ViewModel { get }
}

class CountersBoardViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    private lazy var innerView = CountersBoardView()
    private var editButton: UIBarButtonItem!

    private let presenter: CountersBoardViewPresenter

    init(presenter: CountersBoardViewPresenter) {
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
        additionalSafeAreaInsets = Constants.additionalInsets
        innerView.delegate = self
        innerView.configure(with: presenter.viewModel)
    }

    func setupNavigationBarAndToolbar(_ title: String) {
        guard let navigationController = navigationController else {
            return
        }

        navigationController.isNavigationBarHidden = false
        self.title = title
        navigationController.navigationBar.prefersLargeTitles = true
    }

    func setupNavigationBar(_ editBarButton: UIBarButtonItem) {
        editButton = editBarButton
        navigationItem.leftBarButtonItem = editBarButton
    }

    func setupToolbar(_ toolbarItems: [UIBarButtonItem]) {
        self.toolbarItems = toolbarItems
        navigationController?.setToolbarHidden(false, animated: false)
    }
}

private extension CountersBoardViewController {
    enum Constants {
        static let additionalInsets = UIEdgeInsets(top: 26, left: 39, bottom: 20, right: 39)
    }
}

extension CountersBoardViewController: CountersBoardViewDelegate {
    func setupNavigationControllerWith(title: String, editBarButton: UIBarButtonItem, toolbarItems: [UIBarButtonItem]) {
        setupNavigationBarAndToolbar(title)
        setupNavigationBar(editBarButton)
        setupToolbar(toolbarItems)
    }
}

