//
//  CountersBoardLoadingView.swift
//  Counters
//
//  Created by David A Cespedes R on 4/21/21.
//

import UIKit

/// The view to show when the Counters Board data is loading
class CountersBoardLoadingView: UIView {

    // MARK: - Properties

    private let loaderIndicator = UIActivityIndicatorView()

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with isLoading: Bool) {
        isHidden = !isLoading
        if isLoading {
            loaderIndicator.startAnimating()
        } else {
            loaderIndicator.stopAnimating()
        }
    }
}

// MARK: - Private Implementation

private extension CountersBoardLoadingView {
    func setup() {
        self.backgroundColor = .background
        self.frame = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLoaderIndicator()
        setupConstraints()
    }

    func setupLoaderIndicator() {
        loaderIndicator.hidesWhenStopped = true
        loaderIndicator.style = .large
        loaderIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loaderIndicator)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([

            loaderIndicator.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            loaderIndicator.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
        ])
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CountersDashboardLoading_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreviewContainer { _ in
            let view = CountersBoardLoadingView()
            view.configure(with: true)
            return view
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif

