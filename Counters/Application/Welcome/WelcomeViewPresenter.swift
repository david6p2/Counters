//
//  WelcomeViewPresenter.swift
//  Counters
//
//

import UIKit

protocol WelcomeViewProtocol: class {
    func setup(viewModel: WelcomeView.ViewModel)
    func presentCounterBoard()
}

protocol WelcomeViewPresenterProtocol {
    func viewDidLoad()
    func continuePressed()
}

internal final class WelcomeViewPresenter {

    weak var view: WelcomeViewProtocol?

    private let features: [WelcomeFeatureView.ViewModel] = [
        .init(
            badge: UIImage.badge(sytemIcon: "42.circle.fill",
                                 color: .countersRed),
            title: "WELCOME_ADD_FEATURE_TITLE".localized(),
            subtitle: "WELCOME_ADD_FEATURE_DESCRIPTION".localized()
        ),
        .init(
            badge: UIImage.badge(sytemIcon: "person.2.fill",
                                 color: .countersYellow),
            title: "WELCOME_COUNT_SHARE_FEATURE_TITLE".localized(),
            subtitle: "WELCOME_COUNT_SHARE_FEATURE_DESCRIPTION".localized()
        ),
        .init(
            badge: UIImage.badge(sytemIcon: "lightbulb.fill",
                                 color: .countersGreen),
            title: "WELCOME_COUNT_FEATURE_TITLE".localized(),
            subtitle: "WELCOME_COUNT_FEATURE_DESCRIPTION".localized()
        )]
}

extension WelcomeViewPresenter: WelcomeViewPresenterProtocol {
    
    func viewDidLoad() {
        view?.setup(viewModel: viewModel)
    }

    func continuePressed() {
        view?.presentCounterBoard()
    }

    private var viewModel: WelcomeView.ViewModel {
        
        let welcome = NSMutableAttributedString(string: "WELCOME_TITLE".localized())
        let range = (welcome.string as NSString).range(of: "APP_NAME".localized())
        if range.location != NSNotFound {
            welcome.setAttributes([.foregroundColor: UIColor.accentColor], range: range)
        }
        
        return .init(title: welcome,
                     description: "WELCOME_DESCRIPTION".localized(),
                     features: features,
                     buttonTitle: "WELCOME_PRIMARY_ACTION_TITLE".localized())
    }
}
