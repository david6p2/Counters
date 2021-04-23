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

    weak var navigationController: UINavigationController?

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
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

        let presenter = CountersBoardViewPresenter()
        let vc = CountersBoardViewController(presenter: presenter)
        presenter.view = vc
        vc.coordinator = self
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
}
