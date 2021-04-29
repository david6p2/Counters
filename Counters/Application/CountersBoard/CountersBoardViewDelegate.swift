//
//  CountersBoardViewDelegate.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

/// CountersDashboard actions
protocol CountersBoardViewDelegate: class {
    func setupNavigationControllerWith(title: String,
                                       editBarButton: UIBarButtonItem,
                                       selectAllBarButton: UIBarButtonItem?,
                                       searchPlaceholder: String,
                                       toolbarItems: [UIBarButtonItem])
    func cellStepperDidChangeValue(_ counterID: String, stepperChangeType: CounterCardView.StepperChangeType)
    func editButtonWasPressed()
    func selectAllButtonWasPressed()
    func addButtonWasPressed()
    func trashButtonWasPressed()
    func shareButtonWasPressed()
    func pullToRefreshCalled()
}
