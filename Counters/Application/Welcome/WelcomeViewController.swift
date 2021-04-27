//
//  WelcomeViewController.swift
//  Counters
//
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private lazy var innerView = WelcomeView()
    
    private let presenter: WelcomeViewPresenterProtocol

    let userDefaults: KeyValueStorageProtocol

    // MARK: - Initialization

    init(presenter: WelcomeViewPresenterProtocol, userDefaults: KeyValueStorageProtocol = UserDefaults.standard) {
        self.presenter = presenter
        self.userDefaults = userDefaults
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
        presenter.viewDidLoad()
        innerView.delegate = self
    }
}

extension WelcomeViewController: WelcomeViewProtocol {
    func setup(viewModel: WelcomeView.ViewModel) {
        innerView.configure(with: viewModel)
    }

    func presentCounterBoard() {
        let userDefaults: KeyValueStorageProtocol = UserDefaults.standard
        userDefaults.set(true, forKey: OnboardingKey.welcomeWasShown.rawValue)
        coordinator?.showCountersBoard()
    }
}

private extension WelcomeViewController {
    enum Constants {
        static let additionalInsets = UIEdgeInsets(top: 26, left: 39, bottom: 20, right: 39)
    }
}

extension WelcomeViewController: WelcomeViewDelegate {
    func onContinuePressed() {
        presenter.continuePressed()
    }
}
