//
//  AddCounterViewPresenter.swift
//  Counters
//
//  Created by David A Cespedes R on 4/27/21.
//

import UIKit

protocol AddCounterViewProtocol: class {
    func setup(viewModel: AddCounterViewController.AddCounterViewModel)
    //func presentCounterBoard()
}

protocol AddCounterViewPresenterProtocol {
    func viewDidLoad()
    //func continuePressed()
}

internal final class AddCounterViewPresenter {

    weak var view: AddCounterViewProtocol?

    //VM
}

extension AddCounterViewPresenter: AddCounterViewPresenterProtocol {

    func viewDidLoad() {
        view?.setup(viewModel: viewModel)
    }

    private var viewModel: AddCounterViewController.AddCounterViewModel {

        let examplesAttributedString = NSMutableAttributedString(string: "ADDCOUNTER_EXAMPLE".localized())
        let range = (examplesAttributedString.string as NSString).range(of: "ADDCOUNTER_EXAMPLES_LINK_WORD".localized())
        examplesAttributedString.addAttribute(.link, value: "examples", range: range)
        examplesAttributedString.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)


        return .init(titleString: "ADDCOUNTER_TITLE".localized(),
                     namePlaceholder: "ADDCOUNTER_SEARCHPLACEHOLDER".localized(),
                     exampleString: examplesAttributedString,
                     loading: false)
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
