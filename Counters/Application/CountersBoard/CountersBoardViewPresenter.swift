//
//  CountersBoardViewPresenter.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

/// Protocol used by the Views to comunicate user actions to the Presenter
protocol CountersBoardPresenterProtocol {
    var editModeDisableAction: (() -> Void)? { get set }

    func viewDidLoad(animated: Bool)
    func noContentViewButtonPressed(with type: CountersBoardNoContentView.NoContentViewType)
    func editButtonPressed()
    func selectAllPressed()
    func addButtonPressed()
    func shareButtonPressed()
    func trashButtonPressed(withSelectedItemsIds ids: [String])
    func pullToRefreshCalled()
    func handleCounterIncrease(counterCellVM: CounterCellViewModel)
    func handleCounterDecrease(counterCellVM: CounterCellViewModel)
    func handleCountersDelete(countersIds: [String])
    func updateSearchResultsCalled(with filter: String)
}

/// Protocol used by the Presenter to update the View
protocol CountersBoardViewProtocol: class {
    func setup(viewModel: CountersBoardView.ViewModel, animated: Bool)
    func presentAddNewCounter()
    func toggleEditing()
    func selectAllCounters()
    func shareSelectedCounters()
    func presentDeleteItemsConfirmationAlert(_ items: [String])
    func presentIncreaseDecreaseErrorAlert(with error: CountersError)
    func presentDeleteErrorAlert(with error: CountersError)
    func updateTableData(with countersCellsVMs: [CounterCellViewModel], whileSearching isSearching: Bool)
}


internal final class CountersBoardViewPresenter {

    // MARK: - Properties

    weak var view: CountersBoardViewProtocol?

    private(set) var counterCellsVMs: [CounterCellViewModel] = []
    private(set) var filteredCounterCellsVMs: [CounterCellViewModel] = []

    var currentStateStrategy: CountersBoardState = CountersBoardStateLoading()

    private var filter: String = ""
    private var isSearching = false

    private let api = NetworkingClient()
    private lazy var countersRepository = CounterRepository(apiTaskLoader: NetworkingClientLoader(apiRequest:api))
    private lazy var coreDataRepository = CoreDataRepository()

    var editModeDisableAction: (() -> Void)?

    // MARK: - Presenter Methods

    func getCounters(animated: Bool) {
        countersRepository.getCounters { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let counters):
                guard let counters = counters else {
                    return
                }
                self.counterCellsVMs = counters.map{ CounterCellViewModel(counterModel: $0) }

                // Save in CoreData
                self.saveCountersInDB(counters)

                self.currentStateStrategy = CountersBoardStateHasContent(counters, isSearching: self.isSearching)
                DispatchQueue.main.async {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                }
            case .failure(let error):
                self.handleGetCountersError(animated: animated)
            }
        }
    }


    /// Saves the Counters array in the local Data Base
    /// - Parameter counters: The array of Counters
    func saveCountersInDB(_ counters: [CounterModel]) {
        coreDataRepository.cleanDB()
        counters.forEach { (counter) in
            coreDataRepository.createCounter(counter) { _ in }
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
                    self.counterCellsVMs = localCounters.map{ CounterCellViewModel(counterModel: $0) }

                    self.currentStateStrategy = CountersBoardStateHasContent(localCounters, isSearching: self.isSearching)
                    DispatchQueue.main.async {
                        self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                    }
                }

            case .failure(let error):
                self.currentStateStrategy = CountersBoardStateError()
                DispatchQueue.main.async {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: animated)
                }
            }
        }
    }

    /// Update the Counters filtered array
    /// - Parameters:
    ///   - counterCellsVMs: the arrays of Counter Cell ViewModels that needs to be filtered
    ///   - filter: The string to be used to filter
    /// - Returns: the filtered array of Counter Cells ViewModels
    func updateFiltered(counterCellsVMs: [CounterCellViewModel], with filter: String) -> [CounterCellViewModel] {
        return counterCellsVMs.filter { $0.name.lowercased().contains(filter.lowercased()) }
    }
}

extension CountersBoardViewPresenter: CountersBoardPresenterProtocol {

    // MARK: - CountersBoardPresenterProtocol Methods

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
        view?.toggleEditing()
    }

    func selectAllPressed() {
        view?.selectAllCounters()
    }

    func addButtonPressed() {
        view?.presentAddNewCounter()
    }

    func shareButtonPressed() {
        view?.shareSelectedCounters()
    }

    func trashButtonPressed(withSelectedItemsIds ids: [String]) {
        view?.presentDeleteItemsConfirmationAlert(ids)
    }

    func pullToRefreshCalled() {
        getCounters(animated: true)
    }

    func handleCounterIncrease(counterCellVM: CounterCellViewModel) {
        countersRepository.increaseCounter(id: counterCellVM.id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let counters):
                guard let counters = counters else {
                    return
                }

                self.counterCellsVMs = counters.map{ CounterCellViewModel(counterModel: $0) }
                if self.isSearching {
                    self.filteredCounterCellsVMs = self.updateFiltered(counterCellsVMs: counters.map{ CounterCellViewModel(counterModel: $0) }, with: self.filter)
                }
                let usingCounters: [CounterModel] = self.isSearching ? self.filteredCounterCellsVMs.map{ $0.getModel() } : self.counterCellsVMs.map{ $0.getModel() }
                self.currentStateStrategy = CountersBoardStateHasContent(usingCounters, isSearching: self.isSearching)
                DispatchQueue.main.async {
                    self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: false)
                }
            case .failure(let error):
                let increaseError = CountersError(error: error as NSError,
                                                  type: .increase(id: counterCellVM.id),
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

    func handleCounterDecrease(counterCellVM: CounterCellViewModel) {
        if counterCellVM.count > 0 {
            countersRepository.decreaseCounter(id: counterCellVM.id) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let counters):
                    guard let counters = counters else {
                        return
                    }
                    self.counterCellsVMs = counters.map{ CounterCellViewModel(counterModel: $0) }
                    if self.isSearching {
                        self.filteredCounterCellsVMs = self.updateFiltered(counterCellsVMs: self.counterCellsVMs, with: self.filter)
                    }
                    let usingCounters: [CounterModel] = self.isSearching ? self.filteredCounterCellsVMs.map{ $0.getModel() } : self.counterCellsVMs.map{ $0.getModel() }
                    self.currentStateStrategy = CountersBoardStateHasContent(usingCounters, isSearching: self.isSearching)
                    DispatchQueue.main.async {
                        self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: false)
                    }
                case .failure(let error):
                    let decreaseError = CountersError(error: error as NSError,
                                                      type: .decrease(id: counterCellVM.id),
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
            handleCountersDelete(countersIds: [counterCellVM.id])
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
                        return
                    }
                    self.counterCellsVMs = counters.map{ CounterCellViewModel(counterModel: $0) }
                    if self.isSearching {
                        self.filteredCounterCellsVMs = self.updateFiltered(counterCellsVMs: self.counterCellsVMs, with: self.filter)
                    }
                    let usingCounters: [CounterModel] = self.isSearching ? self.filteredCounterCellsVMs.map{ $0.getModel() } : self.counterCellsVMs.map{ $0.getModel() }
                    if counters.isEmpty && !self.isSearching {
                        self.currentStateStrategy = CountersBoardStateNoContent()
                    } else {
                        self.currentStateStrategy = CountersBoardStateHasContent(usingCounters, isSearching: self.isSearching)
                    }
                    
                    DispatchQueue.main.async {
                        if let editModeDisableAction = self.editModeDisableAction {
                            editModeDisableAction()
                        }

                        self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: true)
                    }
                case .failure(let error):
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
            filteredCounterCellsVMs.removeAll()
            isSearching = false
            // If Counters are empty, we should refresh with NoContent Strategy
            if counterCellsVMs.isEmpty {
                self.currentStateStrategy = CountersBoardStateNoContent()
                if let editModeDisableAction = self.editModeDisableAction {
                    editModeDisableAction()
                }

                self.view?.setup(viewModel: self.currentStateStrategy.viewModel, animated: true)
            } else {
                view?.updateTableData(with: counterCellsVMs, whileSearching: isSearching)
            }
            return
        }

        isSearching = true
        filteredCounterCellsVMs = updateFiltered(counterCellsVMs: counterCellsVMs, with: filter)
        view?.updateTableData(with: filteredCounterCellsVMs, whileSearching: isSearching)
    }
}

