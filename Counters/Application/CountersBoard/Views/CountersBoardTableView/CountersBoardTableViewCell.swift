//
//  CountersBoardTableViewCell.swift
//  Counters
//
//  Created by David A Cespedes R on 4/23/21.
//

import UIKit

class CountersBoardTableViewCell: UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    let counterCardView = CounterCardView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    override func layoutSubviews() {
        superview?.layoutSubviews()
        counterCardView.cornerRadius(radius: 8)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: CounterCellViewModel) {
        counterCardView.configure(with: viewModel)
    }
}

// MARK: - Private Implementation

private extension CountersBoardTableViewCell {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        contentView.addSubview(counterCardView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            counterCardView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 12
            ),
            contentView.trailingAnchor.constraint(
                equalTo: counterCardView.trailingAnchor,
                constant: 12
            ),
            counterCardView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            counterCardView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),
            counterCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 96)
        ])
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CountersBoardTableViewCell_Preview: PreviewProvider {
    static var previews: some View {
        CellPreviewContainer().frame(
            width: UIScreen.main.bounds.width,
            height: 108,
            alignment: .center
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }

    struct CellPreviewContainer: UIViewRepresentable {
        typealias UIViewType = UITableViewCell

        func makeUIView(context: UIViewRepresentableContext<CountersBoardTableViewCell_Preview.CellPreviewContainer>) -> UITableViewCell {
            let view = CountersBoardTableViewCell()

            if let counterCellVM = CountersBoardTableView.ViewModel.mockCounters.counterCellsVMs.first {
                view.configure(with: counterCellVM)
            }

            return view
        }

        func updateUIView(_ uiView: UITableViewCell,
                          context: UIViewRepresentableContext<CountersBoardTableViewCell_Preview.CellPreviewContainer>) {

        }
    }
}
#endif
