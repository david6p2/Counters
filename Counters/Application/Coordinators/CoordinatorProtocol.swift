//
//  CoordinatorProtocol.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

protocol CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] { get }
    var userDefaults: KeyValueStorageProtocol { get }

    init(navigationController: UINavigationController, userDefaults: KeyValueStorageProtocol)

    func start()
    func showCountersBoard()
    func showAddCounterView()
    func counterWasCreated()
}
