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
        var isCreatingCounter: Bool
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var examplesTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    private var saveButton: UIBarButtonItem!
    private let presenter: AddCounterViewPresenterProtocol
    weak var coordinator: MainCoordinator?

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
        setupView()
        presenter.viewDidLoad()
    }

    func configure(with viewModel: AddCounterViewModel) {
        self.title = viewModel.titleString
        nameTextField.placeholder = viewModel.namePlaceholder

        examplesTextView.delegate = self
        let exampleString = NSMutableAttributedString(attributedString: viewModel.exampleString)
        exampleString.addAttribute(.kern, value: Font.kernExamples, range: NSRange(0..<exampleString.length))
        examplesTextView.attributedText = exampleString
        examplesTextView.textColor = .secondaryText
        examplesTextView.linkTextAttributes = [.underlineColor: UIColor.secondaryText]

        changeStateWhenCreatingCounter(viewModel.isCreatingCounter)
    }

    func changeStateWhenCreatingCounter(_ isCreatingCounter: Bool) {
        nameTextField.isEnabled = !isCreatingCounter
        saveButton.isEnabled = !isCreatingCounter

        if isCreatingCounter {
            activityIndicator.startAnimating()
            nameTextField.resignFirstResponder()
            guard let name = nameTextField.text else {
                return
            }
            presenter.addCounterIsLoading(withCounterName: name)
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Actions

private extension AddCounterViewController {

    @objc private func cancel(sender: UIBarButtonItem) {
        print("Cancel button was pressed")
        presenter.cancelButtonPressed()
    }

    @objc private func save(sender: UIBarButtonItem) {
        print("Save button was pressed")
        guard let name = nameTextField.text else {
            return
        }
        presenter.saveButtonPressed(withCounterName: name)
    }

    @IBAction private func nameTextFieldChanged(_ sender: UITextField) {
        print(sender.text!)
        saveButton.isEnabled = sender.text?.isEmpty ?? true ? false : true
    }

    private func examplesLinkWasTapped(withURL url: URL) {
        print("Examples link was tapped")
        presenter.examplesLinkPressed()
    }
}

// MARK: - Private Constants

private extension AddCounterViewController {
    enum Font {
        static let kern: CGFloat = 0.34
        static let kernExamples: CGFloat = 0.3
        static let save = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let name = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let examples = UIFont.systemFont(ofSize: 15, weight: .regular)
    }

    enum Shadow {
        static let opacity: Float = 1
        static let radius: CGFloat = 16
        static let offset = CGSize(width: 0, height: 4)
        static let color = UIColor(white: 0, alpha: 0.02).cgColor
    }
}

// MARK: - Private Implementation

private extension AddCounterViewController {
    func setupView() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .background
        setupEditButton()
        setupSaveButton()
        setupNameTextField()
        setupExamplesTextView()
    }

    func setupEditButton() {
        let editButton = UIBarButtonItem(
            title: "ADDCOUNTER_CANCEL".localized(),
            style: .plain,
            target: self,
            action: #selector(self.cancel(sender:))
        )
        editButton.setTitleTextAttributes([.foregroundColor : UIColor.accentColor], for: .normal)
        editButton.setTitleTextAttributes([.foregroundColor: UIColor.disableText], for: .disabled)
        navigationItem.leftBarButtonItem = editButton
    }

    func setupSaveButton() {
        saveButton = UIBarButtonItem(
            title: "ADDCOUNTER_SAVE".localized(),
            style: .plain,
            target: self,
            action: #selector(self.save(sender:))
        )
        saveButton.setTitleTextAttributes([.foregroundColor : UIColor.accentColor,
                                           .font: Font.save], for: .normal)
        saveButton.setTitleTextAttributes([.foregroundColor: UIColor.disableText,
                                           .font: Font.save], for: .disabled)
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton
    }

    func setupNameTextField() {
        nameTextField.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.name)
        nameTextField.cornerRadius(radius: 8)
        let insetView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 20))
        nameTextField.leftView = insetView
        nameTextField.leftViewMode = .always
        nameTextField.tintColor = .accentColor
        nameTextField.becomeFirstResponder()

        nameTextField.clipsToBounds = false
        nameTextField.layer.shadowRadius = Shadow.radius
        nameTextField.layer.shadowColor = Shadow.color
        nameTextField.layer.shadowOffset = Shadow.offset
        nameTextField.layer.shadowOpacity = Shadow.opacity
    }

    func setupExamplesTextView(){
        examplesTextView.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Font.examples)
        examplesTextView.backgroundColor = .clear
        examplesTextView.textContainerInset = .zero
        examplesTextView.textContainer.lineFragmentPadding = 0
    }

}

// MARK: - UITextViewDelegate Implementation

extension AddCounterViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("Examples TextView tapped with URL: \(URL)")
        examplesLinkWasTapped(withURL: URL)
        return false
    }
}

// MARK: - View Protocol Implementation

extension AddCounterViewController: AddCounterViewProtocol {
    func setup(viewModel: AddCounterViewModel) {
        configure(with: viewModel)
    }

    func popViewController(isCountersRefreshNeeded: Bool) {
        navigationController?.popViewController(animated: true)
    }

    func counterSuccessfullyCreated() {
        coordinator?.counterWasCreated()
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func presentErrorAlert(with error: CountersError) {
        changeStateWhenCreatingCounter(false)

        let addError = CountersError(error: error.error as NSError,
                                     type: error.type,
                                     title: "ADDCOUNTER_ERROR_TITLE".localized(),
                                     message: "ADDCOUNTER_ERROR_SUBTITLE".localized(),
                                     actionTitle: "ADDCOUNTER_ERROR_ACTION".localized(),
                                     retryTitle: nil,
                                     handler: nil)

        self.presentAlert(with: addError)
    }

    func presentExamplesView() {
        coordinator?.showExamplesView()
    }

    func setNameTextField(with name: String) {
        nameTextField.text = name
        nameTextField.becomeFirstResponder()
        nameTextFieldChanged(nameTextField)
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct AddCounter_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreviewContainer { _ in
            let presenter = AddCounterViewPresenter()
            let viewController = AddCounterViewController(presenter: presenter)

            viewController.configure(with: presenter.viewModel)

            return viewController
        }
    }
}
#endif
