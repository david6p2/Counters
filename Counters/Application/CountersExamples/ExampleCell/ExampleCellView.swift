//
//  ExampleCellView.swift
//  Counters
//
//  Created by David A Cespedes R on 5/1/21.
//

import UIKit

class ExampleCellView: UICollectionViewCell {
    let label = UILabel()
    static let reuseIdentifier = "text-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

extension ExampleCellView {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        contentView.backgroundColor = .systemGreen
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topInset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomInset),
            label.heightAnchor.constraint(equalToConstant: Constants.labelHeight)
        ])
    }
}

private extension ExampleCellView {
    enum Constants {
        static let horizontalInset = CGFloat(20)
        static let topInset = CGFloat(17)
        static let bottomInset = CGFloat(18)
        static let labelHeight = CGFloat(20)
    }
}
