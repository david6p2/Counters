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
    func handelCounterIncrease()
    func handelCounterDecrease()
}

protocol CountersBoardViewProtocol: class {
    func setup(viewModel: CountersBoardView.ViewModel)
}

internal final class CountersBoardViewPresenter: CountersBoardPresenterProtocol {
    weak var view: CountersBoardViewProtocol?
    var currentStateStrategy: CountersBoardState = CountersBoardStateLoading()

    func viewDidLoad() {
        view?.setup(viewModel: currentStateStrategy.viewModel)
        let client = NetworkingClient.init()
        client.getCounters { (result) in
            switch result {
            case .success(let counters):
                print("The counters are: \(counters)")
                let state = CountersBoardStateHasContent(counters)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.view?.setup(viewModel: state.viewModel)
                }
            case .failure(let error):
                print("The error is: \(error)")
            }
        }
    }

    func handleMainActionCTA() {

    }

    func handelCounterIncrease() {

    }

    func handelCounterDecrease() {

    }
}

