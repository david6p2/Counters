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
        return CountersBoardView.ViewModel(parentVM: CountersBoardView.ParentViewModel.defaultVM,
                                           isLoading: true,
                                           noContentVM: .empty,
                                           countersVM: CountersBoardTableView.ViewModel.empty
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
                                           noContentVM: noContentVM,
                                           countersVM: CountersBoardTableView.ViewModel.empty
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
                                           noContentVM: errorVM,
                                           countersVM: CountersBoardTableView.ViewModel.empty
        )
    }
}

class CountersBoardStateHasContent: CountersBoardState {
    var isSearching: Bool = false
    var counters: [CounterModelProtocol]
    var viewModel: CountersBoardView.ViewModel {
        let noContentVM: CountersBoardNoContentView.ViewModel = .init(title: "COUNTERSDASHBOARD_NO_CONTENT_TITLE".localized(),
                                                                      subtitle: "COUNTERSDASHBOARD_NO_CONTENT_SUBTITLE".localized(),
                                                                      buttonTitle: "COUNTERSDASHBOARD_NO_CONTENT_BUTTONTITLE".localized(),
                                                                      isHidden: !counters.isEmpty || isSearching
        )

        var parentVM = CountersBoardView.ParentViewModel.defaultVM
        parentVM.isEditEnabled = noContentVM.isHidden

        let countersVM = CountersBoardTableView.ViewModel(counters: counters,
                                                          noResultsString: "COUNTERSDASHBOARD_NO_RESULTS_MESSAGE".localized(),
                                                          isSearching: isSearching)

        return CountersBoardView.ViewModel(parentVM: parentVM,
                                           isLoading: false,
                                           noContentVM: noContentVM,
                                           countersVM: countersVM
        )
    }

    init(_ counters: [CounterModelProtocol], isSearching: Bool) {
        self.counters = counters
        self.isSearching = isSearching
    }
}
