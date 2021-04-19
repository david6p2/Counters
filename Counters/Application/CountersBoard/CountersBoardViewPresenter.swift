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
            title: "COUNTERSDASHBOARD_NO_CONTENT_TITLE".localized(),
            subtitle: "COUNTERSDASHBOARD_NO_CONTENT_SUBTITLE".localized(),
            buttonTitle: "COUNTERSDASHBOARD_NO_CONTENT_BUTTONTITLE".localized())
}

extension CountersBoardViewPresenter: CountersBoardViewControllerPresenter {
    var viewModel:  CountersBoardView.ViewModel {
        return .init(titleString: "COUNTERSDASHBOARD_TITLE".localized(),
                     editString: "COUNTERSDASHBOARD_EDIT".localized(),
                     searchPlaceholder: "COUNTERSDASHBOARD_SEARCHPLACEHOLDER".localized(),
                     noCounters: noCountersVM)
    }
}

