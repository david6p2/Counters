//
//  CounterCardView.swift
//  Counters
//
//  Created by David A Cespedes R on 4/16/21.
//

import UIKit

class CounterCardView: UIView {

    // MARK: - Properties

    let separator = UIView(frame: .zero)
    let counter = UILabel()
    let title = UILabel()
    let stepper = UIStepper()

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with counter: CounterModelProtocol) {
        self.counter.text = String(counter.count)
        self.counter.textColor =  counter.count ==  0 ? .background : .accentColor
        title.text = counter.title
        tintColor = .accentColor
    }
}

// MARK: - Private definitions

private extension CounterCardView {
    enum CountFont {
        static let kern: CGFloat = -0.41
        static let lineHeightMultiple: CGFloat = 0.77
        static let title = UIFont(name: "SFProRounded-Semibold", size: 24)!
    }

    enum TitleFont {
        static let kern: CGFloat = 0.34
        static let title = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
}

// MARK: - Private Implementation

private extension CounterCardView {
    func setup() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        setupSeparator()
        setupCounter()
        setupTitle()
        setupStepper()
        setupHierarchy()
        setupConstraints()
    }

    func setupSeparator() {
        separator.backgroundColor = .background
        separator.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupCounter() {
        counter.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: CountFont.title)
        counter.textAlignment = .right

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = CountFont.lineHeightMultiple

        counter.attributedText = .init(string: counter.text ?? "", attributes: [.kern: CountFont.kern, .paragraphStyle: paragraphStyle])
        counter.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupTitle() {
        title.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: TitleFont.title)
        title.attributedText = .init(string: title.text ?? "", attributes: [.kern: TitleFont.kern])
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupStepper() {
        stepper.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupHierarchy() {
        addSubview(separator)
        addSubview(counter)
        addSubview(title)
        addSubview(stepper)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Separator
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 60),
            separator.leadingAnchor.constraint(equalTo: counter.trailingAnchor,
                                               constant: 10),
            separator.widthAnchor.constraint(equalToConstant: 2),

            // Counter
            counter.topAnchor.constraint(equalTo: topAnchor,
                                         constant: 15),
            counter.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: 0),

            // Title
            title.leadingAnchor.constraint(equalTo: separator.trailingAnchor,
                                           constant: 10),
            title.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: 14),
            title.topAnchor.constraint(equalTo: topAnchor,
                                       constant: 16),


            // Stepper
            stepper.topAnchor.constraint(greaterThanOrEqualTo: title.bottomAnchor,
                                          constant: 9),
            bottomAnchor.constraint(equalTo: stepper.bottomAnchor,
                                            constant: 14),
            trailingAnchor.constraint(equalTo: stepper.trailingAnchor,
                                              constant: 14),
            stepper.widthAnchor.constraint(equalToConstant: 100),
            stepper.heightAnchor.constraint(equalToConstant: 29)
        ])
    }


}
#if canImport(SwiftUI) && DEBUG
import SwiftUI

class ViewModel {
    internal init(counter: CounterModelProtocol) {
        self.counter = counter
    }

    var counter: CounterModelProtocol
    @objc func valueChanged(sender: UIStepper) {
        self.counter.count = Int(sender.value)
    }
}

struct CounterCard_Preview: PreviewProvider {
    static var viewModel = ViewModel(counter: CounterModel(id: "Title1",
                                                           title: "Apples eaten",
                                                           count: 0))
    static var viewModel2 = ViewModel(counter: CounterModel(id: "Title2",
                                                            title: "Number of times I’ve forgotten my mother’s name because I was high on Frugelés.",
                                                            count: 10))
    static var previews: some View {
        Group {
            UIViewPreviewContainer { _ in
                let view = CounterCardView()
                view.stepper.addTarget(viewModel,
                                       action: #selector(viewModel.valueChanged(sender:)), for: .valueChanged)
                view.configure(with: viewModel.counter)
                return view
            }
            .padding()
            .previewLayout(.fixed(width: 444, height: 108))
            
            UIViewPreviewContainer { _ in
                let view = CounterCardView()
                view.stepper.addTarget(viewModel2,
                                       action: #selector(viewModel2.valueChanged(sender:)), for: .valueChanged)
                view.configure(with: viewModel2.counter)
                return view
            }
            .preferredColorScheme(.dark)
            .padding()
            .previewLayout(.fixed(width: 444, height: 108))
        }
    }
}
#endif
