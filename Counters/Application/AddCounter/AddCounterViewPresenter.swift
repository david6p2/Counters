//
//  AddCounterViewPresenter.swift
//  Counters
//
//  Created by David A Cespedes R on 4/27/21.
//

import UIKit

protocol AddCounterViewProtocol: class {
    func setup(viewModel: AddCounterViewController.AddCounterViewModel)
    func popViewController(isCountersRefreshNeeded: Bool)
    func counterSuccessfullyCreated()
    func presentExamplesView()
    func setNameTextField(with name: String)
}

protocol AddCounterViewPresenterProtocol {
    func viewDidLoad()
    func cancelButtonPressed()
    func saveButtonPressed(withCounterName name: String)
    func addCounterIsLoading(withCounterName name: String)
    func examplesLinkPressed()
    func setExampleName(with name: String)
}

internal final class AddCounterViewPresenter {

    let api = NetworkingClient()
    lazy var countersRepository = CounterRepository(apiTaskLoader: NetworkingClientLoader(apiRequest:api))

    weak var view: AddCounterViewProtocol?

    //VM
    var viewModel: AddCounterViewController.AddCounterViewModel {

        let examplesAttributedString = NSMutableAttributedString(string: "ADDCOUNTER_EXAMPLE".localized())
        let range = (examplesAttributedString.string as NSString).range(of: "ADDCOUNTER_EXAMPLES_LINK_WORD".localized())
        examplesAttributedString.addAttribute(.link, value: "examples", range: range)
        examplesAttributedString.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)


        return .init(titleString: "ADDCOUNTER_TITLE".localized(),
                     namePlaceholder: "ADDCOUNTER_SEARCHPLACEHOLDER".localized(),
                     exampleString: examplesAttributedString,
                     isCreatingCounter: false)
    }
}

extension AddCounterViewPresenter: AddCounterViewPresenterProtocol {

    func viewDidLoad() {
        view?.setup(viewModel: viewModel)
    }

    func cancelButtonPressed() {
        view?.popViewController(isCountersRefreshNeeded: false)
    }

    func saveButtonPressed(withCounterName: String) {
        var viewModelLoading = self.viewModel
        viewModelLoading.isCreatingCounter = true
        view?.setup(viewModel: viewModelLoading)
    }

    func addCounterIsLoading(withCounterName name: String) {
        print("Call service to create")
        countersRepository.createCounter(name: name) { [weak self] (result) in
            switch result {
            case .success(let counters):
                print("The counters when Create are: \(String(describing: counters))")
                guard counters != nil else {
                    print("The error in Create success is: there are no counters")
                    return
                }
                self?.view?.counterSuccessfullyCreated()
            case .failure(let error):
                print("The error for addCounterIsLoading is: \(error)")
            }
        }
    }

    func examplesLinkPressed() {
        print("examples Link was Pressed")
        view?.presentExamplesView()
    }

    func setExampleName(with name: String) {
        view?.setNameTextField(with: name)
    }
}
