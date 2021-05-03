//
//  UIView+Extension.swift
//  Counters
//
//  Created by David A Cespedes R on 4/16/21.
//

import UIKit

public extension Collection where Element == UIView {
    func addSubviewsForAutolayout(to superview: UIView) {
        superview.addSubviewsForAutolayout(self)
    }
}

/// ` UIView` extension
public extension UIView {
    /// A convenience method that adds subviews, in the order they appear and sets them to use autolayout.
    ///
    /// - Parameter views: The views to be added to the view's hierarchy. They are added in the order they appear, and are therefore Z-aligned bottom to top.
    @discardableResult
    func addSubviewsForAutolayout(_ views: UIView...) -> UIView {
        return addSubviewsForAutolayout(views)
    }

    /// A convenience method that adds subviews, in the order they appear and sets them to use autolayout.
    ///
    /// - Parameter views: The views to be added to the view's hierarchy. They are added in the order they appear, and are therefore Z-aligned bottom to top.
    @discardableResult
    func addSubviewsForAutolayout<C: Collection>(_ views: C) -> UIView where C.Element == UIView {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        return self
    }

    func addUnsafeFillSubView(_ view: UIView) {
        self.addSubviewsForAutolayout(view)
        view.unsafeFill(self)
    }
}

public extension UIView {
    /// Convenience method for adding constraints pinned to the edges of an abrirary view. Ignores safe area
    func unsafeFill(_ other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor),
            topAnchor.constraint(equalTo: other.topAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor),
        ])
    }

    func unsafeFillSuperview() {
        superview.flatMap(unsafeFill(_:))
    }

    /// Convenience method for adding constraints pinned to the safe area of an abrirary view
    func safeFill(_ other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: other.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.safeAreaLayoutGuide.trailingAnchor),
            topAnchor.constraint(equalTo: other.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: other.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

public extension UIView {

    /// Round the corners of a `UIView` using a UIBezierPath
    /// - Parameters:
    ///   - corners: The corners of the rectange
    ///   - radius: The radius you want to give to the corners
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let mask = CAShapeLayer()
        mask.frame = layer.bounds
        mask.path = path.cgPath

        layer.mask = mask
    }

    /// Add rounded corners by modifing the `cornerRadius` of the `layer`
    /// - Parameter radius: The radius you want to give to the corners
    func cornerRadius(radius: CGFloat = 10) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

public extension UIView {
    static var spacer: Self { .init() }

    static func label(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
}

public extension UIViewController {
    internal func presentAlert(with countersError: CountersError) {
        var errorMessage = ""
        if let userInfoMessage = countersError.error.userInfo["message"] as? String {
            errorMessage = userInfoMessage
        } else if let localizedDescription = countersError.error.userInfo[NSLocalizedDescriptionKey] as? String {
            errorMessage = localizedDescription
        }

        let alert = UIAlertController(
            title: countersError.title,
            message: (countersError.message ?? "") + " {" + errorMessage + "}.",
            preferredStyle: .alert
        )
        alert.view.tintColor = UIColor.accentColor
        alert.addAction(UIAlertAction(title: countersError.actionTitle, style: .default, handler: nil))
        if let retryTitle = countersError.retryTitle {
            alert.addAction(UIAlertAction(title: retryTitle, style: .cancel, handler: countersError.handler))
        }
        self.present(alert, animated: true)
    }
}

public extension UIStackView {
    @discardableResult
    func addArrangedSubviews(_ views: UIView...) -> Self {
        addArrangedSubviews(views)
        return self
    }

    @discardableResult
    func addArrangedSubviews<C: Collection>(_ views: C) -> Self where C.Element == UIView {
        views.forEach(addArrangedSubview)
        return self
    }

    static func horizontal(
        spacing: CGFloat? = nil,
        distribution: UIStackView.Distribution = .fill,
        _ views: UIView...
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)

        stackView.axis = .horizontal
        stackView.distribution = distribution
        spacing.flatMap { stackView.spacing = $0 }
        return stackView
    }

    static func vertical(
        alignment: UIStackView.Alignment? = nil,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat? = nil,
        _ views: UIView...
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)

        stackView.axis = .vertical
        stackView.distribution = distribution
        spacing.flatMap { stackView.spacing = $0 }
        alignment.flatMap { stackView.alignment = $0 }
        return stackView
    }
}

