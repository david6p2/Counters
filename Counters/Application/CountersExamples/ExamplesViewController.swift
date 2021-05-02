//
//  ExamplesViewController.swift
//  Counters
//
//  Created by David A Cespedes R on 5/1/21.
//

import UIKit

class ExamplesViewController: UIViewController {

    // MARK: - Properties

    private let examplesViewPresenter: ExamplesViewPresenterProtocol
    weak var coordinator: MainCoordinator?
    private lazy var innerView = ExamplesView()

    // MARK: - Initialization

    init(presenter: ExamplesViewPresenterProtocol) {
        self.examplesViewPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = innerView
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        innerView.delegate = self
        examplesViewPresenter.viewDidLoad()
    }
}

// MARK: - Private Implementation

private extension ExamplesViewController {
    func setupView() {
        title = "EXAMPLES_TITLE".localized()
        navigationController?.navigationBar.topItem?.title = "EXAMPLES_BACK".localized()
        navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - View Protocol Implementation

extension ExamplesViewController: ExamplesViewProtocol {
    func setup(viewModel: ExamplesViewModel) {
        innerView.configure(with: viewModel)
    }

    func setSelectedExample(with name: String) {
        coordinator?.exampleWasSelected(with: name)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - View Delegate Implementation

extension ExamplesViewController: ExamplesViewDelegate {
    func oneOfTheExamplesWasTapped(with name: String) {
        examplesViewPresenter.cellPressed(with: name)
    }
}
