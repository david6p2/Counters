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
}

protocol CountersBoardViewProtocol: class {
    func setup(viewModel: CountersBoardView.ViewModel, animated: Bool)
    func presentAddNewCounter()
    func toggleEditing()
    func selectAllCounters()
    func shareSelectedCounters()
    func presentDeleteItemsConfirmationAlert(_ items: [String])
}

internal final class CountersBoardViewPresenter: CountersBoardPresenterProtocol {
    weak var view: CountersBoardViewProtocol?
    var currentStateStrategy: CountersBoardState = CountersBoardStateLoading()

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
                let state = CountersBoardStateHasContent(counters)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.view?.setup(viewModel: state.viewModel, animated: animated)
                }
            case .failure(let error):
                print("The error for getCounters is: \(error)")
                let state = CountersBoardStateError()
                DispatchQueue.main.async {
                    self.view?.setup(viewModel: state.viewModel, animated: animated)
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
                let state = CountersBoardStateHasContent(counters)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.view?.setup(viewModel: state.viewModel, animated: false)
                }
            case .failure(let error):
                print("The error for handleCounterIncrease is: \(error)")
                let error = error as NSError
                if let message = error.userInfo["message"] {
                    print(message)
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
                    let state = CountersBoardStateHasContent(counters)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.view?.setup(viewModel: state.viewModel, animated: false)
                    }
                case .failure(let error):
                    print("The error for handleCounterDecrease is: \(error)")
                }
            }
        } else {
            handleCountersDelete(countersIds: [counter.id])
        }
    }

    func handleCountersDelete(countersIds: [String]) {
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
                    let state: CountersBoardState = counters.isEmpty ? CountersBoardStateNoContent() : CountersBoardStateHasContent(counters)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let editModeDisableAction = self.editModeDisableAction {
                            editModeDisableAction()
                        }

                        self.view?.setup(viewModel: state.viewModel, animated: true)
                    }
                case .failure(let error):
                    print("The error for handleCountersDelete is: \(error)")
                }
            }
        }
    }
}

