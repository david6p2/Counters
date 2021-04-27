//
//  AddCounterViewController.swift
//  Counters
//
//  Created by David A Cespedes R on 4/26/21.
//

import UIKit

class AddCounterViewController: UIViewController {
    // MARK: - View Model

    struct AddCounterViewModel {
        let titleString: String
        let namePlaceholder: String
        let exampleString: NSAttributedString
        let loading: Bool
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var examplesLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    weak var coordinator: MainCoordinator?
    private var saveButton: UIBarButtonItem!

    private let presenter: AddCounterViewPresenterProtocol

    // MARK: - Initialization

    init(presenter: AddCounterViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    func configure(with viewModel: AddCounterViewModel) {
        self.title = viewModel.titleString
        nameTextField.placeholder = viewModel.namePlaceholder

        examplesLabel.attributedText = viewModel.exampleString
        examplesLabel.isUserInteractionEnabled = true

        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.examplesTapped(_:)))
        examplesLabel.addGestureRecognizer(labelTap)

        viewModel.loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    @objc private func examplesTapped(_ sender: UITapGestureRecognizer) {
        print("Examples tapped")
    }
}

// MARK: - View Protocol Implementation

extension AddCounterViewController: AddCounterViewProtocol {
    func setup(viewModel: AddCounterViewModel) {
        configure(with: viewModel)
    }
}
