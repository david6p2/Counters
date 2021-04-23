//
//  AppDelegate.swift
//  Counters
//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navController = UINavigationController()
        navController.navigationBar.prefersLargeTitles = true
        coordinator = MainCoordinator(navigationController: navController, userDefaults: UserDefaults.standard)
        coordinator?.start()

        let window = UIWindow()
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

