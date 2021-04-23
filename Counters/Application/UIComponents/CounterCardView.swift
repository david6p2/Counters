//
//  CounterCardView.swift
//  Counters
//
//  Created by David A Cespedes R on 4/16/21.
//

import UIKit

class CounterCardView: UIView {

    // MARK: - Properties

    let separator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .background
        return view
    }()

    let counter: UILabel = {
        let label = UILabel()
        label.textColor = label.text ==  "0" ? .background : .accentColor
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: CountFont.title)

        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = CountFont.lineHeightMultiple

        label.attributedText = .init(string: label.text ?? "", attributes: [.kern: CountFont.kern, .paragraphStyle: paragraphStyle])
        return label
    }()

    let title: UILabel = {
        let title = UILabel()
        title.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: TitleFont.title)

        title.attributedText = .init(string: title.text ?? "", attributes: [.kern: TitleFont.kern])
        return title
    }()

    let stepper: UIStepper = .init()

    // MARK: - init

    init() {
        super.init(frame: .zero)
        self.addUnsafeFillSubView(
            UIStackView.horizontal(
                UIStackView.vertical(
                    counter,
                    .spacer
                ),
                separator,
                UIStackView.vertical(
                    title,
                    .spacer
                ),
                .spacer,
                UIStackView.vertical(
                    .spacer,
                    stepper
                )
            )
        )
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: counter.trailingAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 10),
            separator.widthAnchor.constraint(equalToConstant: 2)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with counter: CounterModelProtocol) {
        self.counter.text = String(counter.count)
        title.text = counter.title
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
                                                           title: "Title",
                                                           count: 0))
    static var viewModel2 = ViewModel(counter: CounterModel(id: "Title2",
                                                            title: "Title",
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
            .previewLayout(.fixed(width: 351, height: 96))
            UIViewPreviewContainer { _ in
                let view = CounterCardView()
                view.stepper.addTarget(viewModel2,
                                       action: #selector(viewModel2.valueChanged(sender:)), for: .valueChanged)
                view.configure(with: viewModel2.counter)
                return view
            }
            .preferredColorScheme(.dark)
            .padding()
            .previewLayout(.fixed(width: 351, height: 96))
        }
    }
}
#endif
