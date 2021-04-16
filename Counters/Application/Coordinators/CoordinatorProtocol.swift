//
//  CoordinatorProtocol.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

protocol CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] { get }

    init(navigationController: UINavigationController)

    func start()
}
