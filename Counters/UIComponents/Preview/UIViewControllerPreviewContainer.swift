#if canImport(SwiftUI) && DEBUG
import UIKit
import SwiftUI

/// Creates a UIViewControllerRepresentable over any UIViewController.
public struct UIViewControllerPreviewContainer: UIViewControllerRepresentable {

    public typealias UIViewControllerType = UIViewController

    let makeUIViewControllerHandler: (Context) -> UIViewControllerType
    let updateUIViewControllerHandler: ((UIViewController, Context) -> Void)?

    public init(
        makeUIViewControllerHandler: @escaping (Context) -> UIViewControllerType,
        updateUIViewControllerHandler: ((UIViewController, Context) -> Void)?
    ) {
        self.makeUIViewControllerHandler = makeUIViewControllerHandler
        self.updateUIViewControllerHandler = updateUIViewControllerHandler
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        makeUIViewControllerHandler(context)
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        updateUIViewControllerHandler?(uiViewController, context)
    }
}

#endif
