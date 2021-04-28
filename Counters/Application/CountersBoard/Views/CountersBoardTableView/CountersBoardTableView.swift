//
//  CountersBoardTableView.swift
//  Counters
//
//  Created by David A Cespedes R on 4/23/21.
//

import UIKit

class CountersBoardTableView: UITableView {

    // MARK: - View Model
    /// The CountersBoard TableView ViewModel
    struct ViewModel {
        /// Counters Array for the Table
        let counters: [CounterModelProtocol]

        /// Mock Counter ViewModel to test when there's no data from the server
        static var mockCounters: ViewModel = .init(
            counters: [
                CounterModel(id: "Title1",
                             title: "Apples eaten",
                             count: 0),
                CounterModel(id: "Title2",
                             title: "Number of times I’ve forgotten my mother’s name because I was high on Frugelés.",
                             count: 10)
            ]
        )

        /// Empty Counters ViewModel to test the case when there are no counters
        static var empty: ViewModel = .init(counters: [])
    }

    // MARK: - Properties

    weak var configureDelegate: CountersBoardTableViewConfigureDelegate?

    // MARK: - Initialization

    init() {
        super.init(frame: .zero, style: .plain    )
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with counters: [CounterModelProtocol], animated: Bool) {
        self.register(CountersBoardTableViewCell.self, forCellReuseIdentifier: CountersBoardTableViewCell.reuseIdentifier)
        isHidden = counters.isEmpty
        configureDelegate?.isCallingConfigure(with: counters, animated: animated)
    }
}

// MARK: - Private Implementation

private extension CountersBoardTableView {
    func setup() {
        self.backgroundColor = .background
        self.frame = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            self.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
        ])
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CountersBoardTableView_Preview: PreviewProvider {
    static var previews: some View {
        TablePreviewContainer()
            .frame(width: UIScreen.main.bounds.width,
                   height: 108,
                   alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
            .previewLayout(.sizeThatFits)
    }

    struct TablePreviewContainer: UIViewRepresentable {
        typealias UIViewType = UITableView

        func makeUIView(context: UIViewRepresentableContext<CountersBoardTableView_Preview.TablePreviewContainer>) -> UITableView {
            return CountersBoardTableView()
        }

        func updateUIView(_ uiView: UITableView,
                          context: UIViewRepresentableContext<CountersBoardTableView_Preview.TablePreviewContainer>) {

        }
    }
}
#endif
