//
//  CountersBoardViewPresenter.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

internal final class CountersBoardViewPresenter {
    private let noCountersVM: CountersBoardNoContentView.ViewModel =
        .init(
            title: NSLocalizedString("COUNTERSDASHBOARD_NO_CONTENT_TITLE", comment: ""),
            subtitle: NSLocalizedString("COUNTERSDASHBOARD_NO_CONTENT_SUBTITLE", comment: ""),
            buttonTitle: NSLocalizedString("COUNTERSDASHBOARD_NO_CONTENT_BUTTONTITLE", comment: ""))
}

extension CountersBoardViewPresenter: CountersBoardViewControllerPresenter {
    var viewModel:  CountersBoardView.ViewModel {
        return .init(title: NSLocalizedString("COUNTERSDASHBOARD_TITLE", comment: ""),
                     noCounters: noCountersVM)
    }
}

