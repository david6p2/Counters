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

internal final class CountersBoardViewPresenter {
    weak var view: CountersBoardViewProtocol?
    var currentStateStrategy: CountersBoardState = CountersBoardStateLoading()
    private(set) var counters: [CounterModelProtocol] = []
    private(set) var filteredCounters: [CounterModelProtocol] = []
    var filter: String = ""
    var isSearching = false

    let api = NetworkingClient()
    lazy var countersRepository = CounterRepository(apiTaskLoader: NetworkingClientLoader(apiRequest:api))
    lazy var coreDataRepository = CoreDataRepository()

    var editModeDisableAction: (() -> Void)?

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

                // Save in CoreData
                self.saveCountersInDB(self.counters)

                self.currentStateStrategy = CountersBoardStateHasContent(counters, isSearching: self.isSearching)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                }
            case .failure(let error):
                print("The error for getCounters is: \(error)")
                self.handleGetCountersError(animated: animated)
            }
        }
    }


    /// Saves the Counters array in the local Data Base
    /// - Parameter counters: The array of Counters
    func saveCountersInDB(_ counters: [CounterModelProtocol]) {
        coreDataRepository.cleanDB()
        counters.forEach { (counter) in
            coreDataRepository.createCounter(counter) { (result) in
                switch result {
                case .success(let counters):
                    print("\(String(describing: counters?.first)) -> saved")
                case .failure(let error):
                    print("Error saving Counter \(error)")
                }

            }
        }
        coreDataRepository.saveContext()
    }

    /// The app should persist the counter list if the network is not available
    func handleGetCountersError(animated: Bool) {
        coreDataRepository.getCounters { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let localCounters):
                guard let localCounters = localCounters else {
                    return
                }

                // If there is no local data we are going to the Error State
                if localCounters.isEmpty {
                    self.currentStateStrategy = CountersBoardStateError()
                    DispatchQueue.main.async {
                        self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                    }
                    return
                }
                // If we have local data we are going to show the error for a few seconds and then the local counters
                self.currentStateStrategy = CountersBoardStateError()

                DispatchQueue.main.async {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.counters = localCounters

                    self.currentStateStrategy = CountersBoardStateHasContent(self.counters, isSearching: self.isSearching)
                    DispatchQueue.main.async {
                        self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                    }
                }

            case .failure(let error):
                print("Error Showing Local Counters \(error)")
                self.currentStateStrategy = CountersBoardStateError()
                DispatchQueue.main.async {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                }
            }
        }
    }
}

extension CountersBoardViewPresenter: CountersBoardPresenterProtocol {

    func viewDidLoad(animated: Bool) {
        view?.setup(viewModel: currentStateStrategy.viewModel, animated: animated)
        getCounters(animated: false)
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
            // If Counters are empty, we should refresh with NoContent Strategy
            if counters.isEmpty {
                self.currentStateStrategy = CountersBoardStateNoContent()
                if let editModeDisableAction = self.editModeDisableAction {
                    editModeDisableAction()
                }

                self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: true)
            } else {
                view?.updateTableData(with: counters, whileSearching: isSearching)
            }
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

