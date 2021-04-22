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
    }

    func handleMainActionCTA() {

    }

    func handelCounterIncrease() {

    }

    func handelCounterDecrease() {

    }
}

