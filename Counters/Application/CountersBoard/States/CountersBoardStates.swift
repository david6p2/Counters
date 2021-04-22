//
//  CountersBoardStates.swift
//  Counters
//
//  Created by David A Cespedes R on 4/19/21.
//

import Foundation

enum CountersBoardStates<CounterData> {
    case loading
    case noContent
    case hasContent(_ content: CounterData)
    case error(_ error: Error)
}

protocol CountersBoardState { //El VM Usa esto comoo un state para delegarle al state
    var viewModel: CountersBoardView.ViewModel { get }
}

class CountersBoardStateLoading: CountersBoardState {
    var viewModel: CountersBoardView.ViewModel {
        return CountersBoardView.ViewModel(titleString: "Loading".localized(), editString: "COUNTERSDASHBOARD_EDIT".localized(), searchPlaceholder: "COUNTERSDASHBOARD_SEARCHPLACEHOLDER".localized(), isLoading: true, noContent: .empty)
    }
}

class CountersBoardStateNoContent: CountersBoardState {
    var viewModel: CountersBoardView.ViewModel {
        return CountersBoardView.ViewModel(titleString: "COUNTERSDASHBOARD_TITLE".localized(),
                                           editString: "COUNTERSDASHBOARD_EDIT".localized(),
                                           searchPlaceholder: "COUNTERSDASHBOARD_SEARCHPLACEHOLDER".localized(),
                                           isLoading: false,
                                           noContent: .init(
                                            title: "COUNTERSDASHBOARD_NO_CONTENT_TITLE".localized(),
                                            subtitle: "COUNTERSDASHBOARD_NO_CONTENT_SUBTITLE".localized(),
                                            buttonTitle: "COUNTERSDASHBOARD_NO_CONTENT_BUTTONTITLE".localized(),
                                            isHidden: false
                                           )
        )
    }
}

class CountersBoardStateError: CountersBoardState {
    var viewModel: CountersBoardView.ViewModel {
        return CountersBoardView.ViewModel(titleString: "COUNTERSDASHBOARD_TITLE".localized(),
                                           editString: "COUNTERSDASHBOARD_EDIT".localized(),
                                           searchPlaceholder: "COUNTERSDASHBOARD_SEARCHPLACEHOLDER".localized(),
                                           isLoading: false,
                                           noContent: .init(
                                            title: "COUNTERSDASHBOARD_ERROR_TITLE".localized(),
                                            subtitle: "COUNTERSDASHBOARD_ERROR_SUBTITLE".localized(),
                                            buttonTitle: "COUNTERSDASHBOARD_ERROR_BUTTONTITLE".localized(),
                                            isHidden: false
                                           )
        )
    }
}
