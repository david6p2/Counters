//
//  CountersBoardViewPresenter.swift
//  Counters
//
//  Created by David A Cespedes R on 4/15/21.
//

import UIKit

protocol CountersBoardPresenterProtocol {
    //var viewModel: CountersBoardView.ViewModel { get }

    func viewDidLoad()
    
    func handleMainActionCTA()
    func handleEditCounters()
    func handleCreateCounter(withName  name: String)
    func handleCounterIncrease(counterId: String)
    func handleCounterDecrease(counterId: String)
    func handleCounterDelete(counterId: String)
}

protocol CountersBoardViewProtocol: class {
    func setup(viewModel: CountersBoardView.ViewModel)
    func presentAddNewCounter()
}

internal final class CountersBoardViewPresenter: CountersBoardPresenterProtocol {
    weak var view: CountersBoardViewProtocol?
    var currentStateStrategy: CountersBoardState = CountersBoardStateLoading()

    let api = NetworkingClient()
    lazy var countersRepository = CounterRepository(apiTaskLoader: NetworkingClientLoader(apiRequest:api))

    func viewDidLoad() {
        view?.setup(viewModel: currentStateStrategy.viewModel)

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
                    self.view?.setup(viewModel: state.viewModel)

//                    countersRepository.createCounter(name: "Test") { (result) in
//                        switch result {
//                        case .success(let counters):
//                            print("The counters when Create are: \(counters)")
//                            guard let counters = counters else {
//                                print("The error in Create success is: there are no counters")
//                                return
//                            }
//                            let state = CountersBoardStateHasContent(counters)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                self.view?.setup(viewModel: state.viewModel)
//                            }
//                        case .failure(let error):
//                            print("The error is: \(error)")
//                        }
//                    }



//

//                    countersRepository.deleteCounter(id: "kny33d74") { [weak self] (result) in
//                        guard let self = self else { return }
//                        switch result {
//                        case .success(let counters):
//                            guard let counters = counters else {
//                                print("The error in Delete success is: there are no counters")
//                                return
//                            }
//                            print("The counters when Delete are: \(counters)")
//                            let state = CountersBoardStateHasContent(counters)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                self.view?.setup(viewModel: state.viewModel)
//                            }
//                        case .failure(let error):
//                            print("The error is: \(error)")
//                        }
//                    }
                }
            case .failure(let error):
                print("The error is: \(error)")
            }
        }
    }

    func handleMainActionCTA() {

    }

    func handleEditCounters() {
        print("Calling Edit counters")
    }

    func handleCreateCounter(withName name: String) {
        print("Calling create counter with name: \(name)")
        view?.presentAddNewCounter()
    }

    func handleCounterIncrease(counterId: String) {
        countersRepository.increaseCounter(id: counterId) { [weak self] (result) in
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
                    self.view?.setup(viewModel: state.viewModel)
                }
            case .failure(let error):
                print("The error is: \(error)")
                if let error = error as? NSError, let message = error.userInfo["message"] {
                    print(message)
                }
            }
        }
    }

    func handleCounterDecrease(counterId: String) {
        countersRepository.decreaseCounter(id: counterId) { [weak self] (result) in
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
                    self.view?.setup(viewModel: state.viewModel)
                }
            case .failure(let error):
                print("The error is: \(error)")
            }
        }
    }

    func handleCounterDelete(counterId: String) {
        print("Calling delete counter \(counterId)")
    }
}

