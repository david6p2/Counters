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
        let parentVM: CountersBoardView.ParentViewModel = .init(titleString: "Loading".localized(),
                                                                editString: "COUNTERSDASHBOARD_EDIT".localized(),
                                                                isEditEnabled: false,
                                                                searchPlaceholder: "COUNTERSDASHBOARD_SEARCHPLACEHOLDER".localized()
        )

        return CountersBoardView.ViewModel(parentVM: parentVM,
                                           isLoading: true,
                                           noContent: .empty
        )
    }
}

class CountersBoardStateNoContent: CountersBoardState {
    var viewModel: CountersBoardView.ViewModel {
        let noContentVM: CountersBoardNoContentView.ViewModel = .init(title: "COUNTERSDASHBOARD_NO_CONTENT_TITLE".localized(),
                                                                    subtitle: "COUNTERSDASHBOARD_NO_CONTENT_SUBTITLE".localized(),
                                                                    buttonTitle: "COUNTERSDASHBOARD_NO_CONTENT_BUTTONTITLE".localized(),
                                                                    isHidden: false
        )

        return CountersBoardView.ViewModel(parentVM: CountersBoardView.ParentViewModel.defaultVM,
                                           isLoading: false,
                                           noContent: noContentVM
        )
    }
}

class CountersBoardStateError: CountersBoardState {
    var viewModel: CountersBoardView.ViewModel {
        let errorVM: CountersBoardNoContentView.ViewModel = .init( title: "COUNTERSDASHBOARD_ERROR_TITLE".localized(),
                                                                     subtitle: "COUNTERSDASHBOARD_ERROR_SUBTITLE".localized(),
                                                                     buttonTitle: "COUNTERSDASHBOARD_ERROR_BUTTONTITLE".localized(),
                                                                     isHidden: false
        )

        return CountersBoardView.ViewModel(parentVM: CountersBoardView.ParentViewModel.defaultVM,
                                           isLoading: false,
                                           noContent: errorVM
        )
    }
}
