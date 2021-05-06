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
    func presentAddCounterErrorAlert(with error: CountersError)
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
        let counter: CounterModel = CounterModel(id: "-1", title: name, count: 0)
        countersRepository.createCounter(counter) { [weak self] (result) in
            switch result {
            case .success(let counters):
                guard counters != nil else {
                    return
                }
                self?.view?.counterSuccessfullyCreated()
            case .failure(let error):
                let addError = CountersError(error: error as NSError,
                                             type: .add(name: name),
                                             title: nil,
                                             message: nil,
                                             actionTitle: nil,
                                             retryTitle: nil,
                                             handler: nil)
                DispatchQueue.main.async {
                    self?.view?.presentAddCounterErrorAlert(with: addError)
                }
            }
        }
    }

    func examplesLinkPressed() {
        view?.presentExamplesView()
    }

    func setExampleName(with name: String) {
        view?.setNameTextField(with: name)
    }
}
