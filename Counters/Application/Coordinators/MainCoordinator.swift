//
//  MainCoordinator.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

class MainCoordinator: CoordinatorProtocol {
    var childCoordinators = [CoordinatorProtocol]()
    private var window = UIWindow(frame: UIScreen.main.bounds)
    private let countersBoardPresenter = CountersBoardViewPresenter()
    internal var userDefaults: KeyValueStorageProtocol

    weak var navigationController: UINavigationController?

    required init(navigationController: UINavigationController, userDefaults: KeyValueStorageProtocol) {
        self.navigationController = navigationController
        self.userDefaults = userDefaults
    }

    func start() {
        if userDefaults.bool(forKey: OnboardingKey.welcomeWasShown.rawValue) {
            showCountersBoard()
        } else {
            showWelcome()
        }
    }

    func showWelcome() {
        guard let navigationController = navigationController else {
            return
        }

        let presenter = WelcomeViewPresenter()
        let vc = WelcomeViewController(presenter: presenter)
        presenter.view = vc
        vc.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func showCountersBoard() {
        guard let navigationController = navigationController else {
            return
        }

        let vc = CountersBoardViewController(presenter: countersBoardPresenter)
        countersBoardPresenter.view = vc
        vc.coordinator = self
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }

    func showAddCounterView() {
        guard let navigationController = navigationController else {
            return
        }

        let presenter = AddCounterViewPresenter()
        let vc = AddCounterViewController(presenter: presenter)
        presenter.view = vc
        vc.coordinator = self
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }

    func counterWasCreated() {
        countersBoardPresenter.currentStateStrategy = CountersBoardStateLoading()
        DispatchQueue.main.async { [weak self] in
            self?.countersBoardPresenter.viewDidLoad(animated: false)
        }
    }
}
