//
//  ExampleHeaderCellView.swift
//  Counters
//
//  Created by David A Cespedes R on 5/1/21.
//

import UIKit

class ExampleHeaderCellView: UICollectionReusableView {
    let label = UILabel()
    static let reuseIdentifier = "example-header-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ExampleHeaderCellView {
    func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: Constants.labelHeight)
        ])
    }
}

private extension ExampleHeaderCellView {
    enum Constants {
        static let horizontalInset = CGFloat(23)
        static let topAnchor = CGFloat(31)
        static let bottomAnchor = CGFloat(10)
        static let labelHeight = CGFloat(16)
    }
}
