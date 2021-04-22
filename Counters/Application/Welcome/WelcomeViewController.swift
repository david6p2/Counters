//
//  WelcomeViewController.swift
//  Counters
//
//

import UIKit

protocol WelcomeViewControllerPresenter {
    func viewDidLoad()
}

protocol WelcomeViewProtocol: class {
    func setup(viewModel: WelcomeView.ViewModel)
}

class WelcomeViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    private lazy var innerView = WelcomeView()
    
    private let presenter: WelcomeViewControllerPresenter
    
    init(presenter: WelcomeViewControllerPresenter) {
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
        navigationController?.isNavigationBarHidden = true
        additionalSafeAreaInsets = Constants.additionalInsets
        presenter.viewDidLoad()
        innerView.delegate = self
    }
}

extension WelcomeViewController: WelcomeViewProtocol {
    func setup(viewModel: WelcomeView.ViewModel) {
        innerView.configure(with: viewModel)
    }


}

private extension WelcomeViewController {
    enum Constants {
        static let additionalInsets = UIEdgeInsets(top: 26, left: 39, bottom: 20, right: 39)
    }
}

extension WelcomeViewController: WelcomeViewDelegate {
    func onContinuePressed() {
        coordinator?.showCountersBoard()
    }
}
