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
    func cellStepperDidChangeValue(_ counterCellVM: CounterCellViewModel, stepperChangeType: CounterCardView.StepperChangeType)
    func editButtonWasPressed()
    func selectAllButtonWasPressed()
    func addButtonWasPressed()
    func trashButtonWasPressed(withSelectedItemsIds ids: [String])
    func shareButtonWasPressed()
    func pullToRefreshWasCalled()
    func noContentButtonWasPressed(with type: CountersBoardNoContentView.NoContentViewType)
}
