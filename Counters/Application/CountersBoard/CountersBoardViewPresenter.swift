//
//  CountersBoardViewPresenter.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

protocol CountersBoardPresenterProtocol {
    var editModeDisableAction: (() -> Void)? { get set }

    func viewDidLoad(animated: Bool)
    func noContentViewButtonPressed(with type: CountersBoardNoContentView.NoContentViewType)
    func editButtonPressed()
    func selectAllPressed()
    func addButtonPressed()
    func shareButtonWasPressed()
    func trashButtonWasPressed(withSelectedItemsIds ids: [String])
    func pullToRefreshCalled()
    func handleCounterIncrease(counter: CounterModelProtocol)
    func handleCounterDecrease(counter: CounterModelProtocol)
    func handleCountersDelete(countersIds: [String])
    func updateSearchResultsCalled(with filter: String)
}

protocol CountersBoardViewProtocol: class {
    func setup(viewModel: CountersBoardView.ViewModel, animated: Bool)
    func presentAddNewCounter()
    func toggleEditing()
    func selectAllCounters()
    func shareSelectedCounters()
    func presentDeleteItemsConfirmationAlert(_ items: [String])
    func presentIncreaseDecreaseErrorAlert(with error: CountersError)
    func presentDeleteErrorAlert(with error: CountersError)
    func updateTableData(with counters: [CounterModelProtocol], whileSearching isSearching: Bool)
}

internal final class CountersBoardViewPresenter: CountersBoardPresenterProtocol {
    weak var view: CountersBoardViewProtocol?
    var currentStateStrategy: CountersBoardState = CountersBoardStateLoading()
    private(set) var counters: [CounterModelProtocol] = []
    private(set) var filteredCounters: [CounterModelProtocol] = []
    var filter: String = ""
    var isSearching = false

    var editModeDisableAction: (() -> Void)?

    let api = NetworkingClient()
    lazy var countersRepository = CounterRepository(apiTaskLoader: NetworkingClientLoader(apiRequest:api))

    func viewDidLoad(animated: Bool) {
        view?.setup(viewModel: currentStateStrategy.viewModel, animated: animated)
        getCounters(animated: false)
    }

    func getCounters(animated: Bool) {
        countersRepository.getCounters { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let counters):
                guard let counters = counters else {
                    print("The error in success is: there are no counters")
                    return
                }
                print("The counters are: \(counters)")
                self.counters = counters
                self.currentStateStrategy = CountersBoardStateHasContent(counters, isSearching: self.isSearching)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                }
            case .failure(let error):
                print("The error for getCounters is: \(error)")
                self.currentStateStrategy = CountersBoardStateError()
                DispatchQueue.main.async {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                }
            }
        }
    }

    func noContentViewButtonPressed(with type: CountersBoardNoContentView.NoContentViewType) {
        switch type {
        case .error:
            getCounters(animated: true)
        case .noContent:
            addButtonPressed()
        default:
            break
        }
    }

    func editButtonPressed() {
        print("Calling Edit counters")
        view?.toggleEditing()
    }

    func selectAllPressed() {
        print("Calling selectAll counters")
        view?.selectAllCounters()
    }

    func addButtonPressed() {
        print("Add Counter was pressed")
        view?.presentAddNewCounter()
    }

    func shareButtonWasPressed() {
        print("Share was pressed")
        view?.shareSelectedCounters()
    }

    func trashButtonWasPressed(withSelectedItemsIds ids: [String]) {
        print("Trash was pressed with Items \(ids)")
        view?.presentDeleteItemsConfirmationAlert(ids)
    }

    func pullToRefreshCalled() {
        print("Pull to refresh called")
        getCounters(animated: true)
    }

    func handleCounterIncrease(counter: CounterModelProtocol) {
        countersRepository.increaseCounter(id: counter.id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let counters):
                guard let counters = counters else {
                    print("The error in Increase success is: there are no counters")
                    return
                }
                print("The counters when Increase are: \(counters)")
                self.counters = counters
                if self.isSearching {
                    self.filteredCounters = self.updateFiltered(counters: counters, with: self.filter)
                }
                let usingCounters: [CounterModelProtocol] = self.isSearching ? self.filteredCounters : self.counters
                self.currentStateStrategy = CountersBoardStateHasContent(usingCounters, isSearching: self.isSearching)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: false)
                }
            case .failure(let error):
                print("The error for handleCounterIncrease is: \(error)")
                let increaseError = CountersError(error: error as NSError,
                                                  type: .increase(id: counter.id),
                                                  title: nil,
                                                  message: nil,
                                                  actionTitle: nil,
                                                  retryTitle: nil,
                                                  handler: nil
                )
                DispatchQueue.main.async {
                    self.view?.presentIncreaseDecreaseErrorAlert(with: increaseError)
                }
            }
        }
    }

    func handleCounterDecrease(counter: CounterModelProtocol) {
        if counter.count > 0 {
            countersRepository.decreaseCounter(id: counter.id) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let counters):
                    guard let counters = counters else {
                        print("The error in Decrease success is: there are no counters")
                        return
                    }
                    print("The counters when Decrease are: \(counters)")
                    self.counters = counters
                    if self.isSearching {
                        self.filteredCounters = self.updateFiltered(counters: counters, with: self.filter)
                    }
                    let usingCounters: [CounterModelProtocol] = self.isSearching ? self.filteredCounters : self.counters
                    self.currentStateStrategy = CountersBoardStateHasContent(usingCounters, isSearching: self.isSearching)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: false)
                    }
                case .failure(let error):
                    print("The error for handleCounterDecrease is: \(error)")
                    let decreaseError = CountersError(error: error as NSError,
                                                      type: .decrease(id: counter.id),
                                                      title: nil,
                                                      message: nil,
                                                      actionTitle: nil,
                                                      retryTitle: nil,
                                                      handler: nil
                    )
                    DispatchQueue.main.async {
                        self.view?.presentIncreaseDecreaseErrorAlert(with: decreaseError)
                    }
                }
            }
        } else {
            handleCountersDelete(countersIds: [counter.id])
        }
    }

    func handleCountersDelete(countersIds: [String]) {
        // TODO Use Operations to dispatch this request in order
        for id in countersIds {
            countersRepository.deleteCounter(id: id) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let counters):
                    guard let counters = counters else {
                        print("The error in Delete success is: there are no counters")
                        return
                    }
                    print("The counters when Delete are: \(counters)")
                    self.counters = counters
                    if self.isSearching {
                        self.filteredCounters = self.updateFiltered(counters: counters, with: self.filter)
                    }
                    let usingCounters: [CounterModelProtocol] = self.isSearching ? self.filteredCounters : self.counters
                    if counters.isEmpty && !self.isSearching {
                        self.currentStateStrategy = CountersBoardStateNoContent()
                    } else {
                        self.currentStateStrategy = CountersBoardStateHasContent(usingCounters, isSearching: self.isSearching)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let editModeDisableAction = self.editModeDisableAction {
                            editModeDisableAction()
                        }

                        self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: true)
                    }
                case .failure(let error):
                    print("The error for handleCountersDelete is: \(error)")
                    let deleteError = CountersError(error: error as NSError,
                                                    type: .delete(id: id),
                                                    title: nil,
                                                    message: nil,
                                                    actionTitle: nil,
                                                    retryTitle: nil,
                                                    handler: nil
                    )
                    DispatchQueue.main.async {
                        self.view?.presentDeleteErrorAlert(with: deleteError)
                    }
                }
            }
        }
    }

    func updateSearchResultsCalled(with filter: String) {
        self.filter = filter
        if filter.isEmpty {
            filteredCounters.removeAll()
            isSearching = false
            view?.updateTableData(with: counters, whileSearching: isSearching)
            return
        }

        isSearching = true
        filteredCounters = updateFiltered(counters: counters, with: filter)
        view?.updateTableData(with: filteredCounters, whileSearching: isSearching)
    }

    func updateFiltered(counters: [CounterModelProtocol], with filter: String) -> [CounterModelProtocol] {
        return counters.filter { $0.title.lowercased().contains(filter.lowercased()) }
    }
}

