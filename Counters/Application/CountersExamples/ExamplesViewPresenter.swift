//
//  ExamplesViewPresenter.swift
//  Counters
//
//  Created by David A Cespedes R on 5/1/21.
//

import UIKit

protocol ExamplesViewProtocol: class {
    func setup(viewModel: ExamplesViewModel)
    func setSelectedExample(with name: String)
}

protocol ExamplesViewPresenterProtocol {
    func viewDidLoad()
    func cellPressed(with name:String)
    func examplesViewDismissed()
}

internal final class ExamplesViewPresenter {
    weak var view: ExamplesViewProtocol?

    var viewModel: ExamplesViewModel {
        return .init(examplesHeaderString: "EXAMPLES_HEADER_TITLE".localized(),
                     examplesViewModel: buildExamplesSectionsViewModels())
    }

    func buildExamplesSectionsViewModels() -> [ExamplesViewModel.ExamplesSectionViewModel] {
        var sections: [ExamplesViewModel.ExamplesSectionViewModel] = []
        sections.append(buildDrinksSection())
        sections.append(buildFoodSection())
        sections.append(buildMiscSection())
        return sections 
    }

    private func buildDrinksSection() -> ExamplesViewModel.ExamplesSectionViewModel {
        ExamplesViewModel.ExamplesSectionViewModel(sectionTitle: "EXAMPLES_SECTION_DRINKS_HEADER_TITLE".localized(),
                                                   sectionExamples: [
                                                    "EXAMPLES_SECTION_DRINKS_ITEM1".localized(),
                                                    "EXAMPLES_SECTION_DRINKS_ITEM2".localized(),
                                                    "EXAMPLES_SECTION_DRINKS_ITEM3".localized(),
                                                    "EXAMPLES_SECTION_DRINKS_ITEM4".localized()
                                                   ]
        )
    }

    private func buildFoodSection() -> ExamplesViewModel.ExamplesSectionViewModel {
        ExamplesViewModel.ExamplesSectionViewModel(sectionTitle: "EXAMPLES_SECTION_FOOD_HEADER_TITLE".localized(),
                                                   sectionExamples: [
                                                    "EXAMPLES_SECTION_FOOD_ITEM1".localized(),
                                                    "EXAMPLES_SECTION_FOOD_ITEM2".localized(),
                                                    "EXAMPLES_SECTION_FOOD_ITEM3".localized(),
                                                    "EXAMPLES_SECTION_FOOD_ITEM4".localized(),
                                                    "EXAMPLES_SECTION_FOOD_ITEM5".localized()
                                                   ]
        )
    }

    private func buildMiscSection() -> ExamplesViewModel.ExamplesSectionViewModel {
        ExamplesViewModel.ExamplesSectionViewModel(sectionTitle: "EXAMPLES_SECTION_MISC_HEADER_TITLE".localized(),
                                                   sectionExamples: [
                                                    "EXAMPLES_SECTION_MISC_ITEM1".localized(),
                                                    "EXAMPLES_SECTION_MISC_ITEM2".localized(),
                                                    "EXAMPLES_SECTION_MISC_ITEM3".localized(),
                                                    "EXAMPLES_SECTION_MISC_ITEM4".localized(),
                                                    "EXAMPLES_SECTION_MISC_ITEM5".localized()
                                                   ]
        )
    }
}

extension ExamplesViewPresenter: ExamplesViewPresenterProtocol {
    func viewDidLoad() {
        view?.setup(viewModel: viewModel)
    }

    func cellPressed(with name: String) {
        view?.setSelectedExample(with: name)
    }

    func examplesViewDismissed() {

    }
}
