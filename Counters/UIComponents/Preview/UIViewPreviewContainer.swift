#if canImport(SwiftUI) && DEBUG
import UIKit
import SwiftUI

/// Creates a UIViewRepresentable over any UIView.
///
/// This will allow to use SwiftUI preview over any UIView.
/// The following example shows how to use it:
///
///     struct LabelPreview: PreviewProvider {
///          static var previews: some View {
///              UIViewPreviewContainer { _ in
///                 let label = Label()
///                 label.text = "Page Title"
///                 return label
///              }
///          }
///     }
public struct UIViewPreviewContainer: UIViewRepresentable {

    public typealias UIViewType = UIView

    let makeUIViewHandler: (
        _ context: UIViewRepresentableContext<Self>
    ) -> UIViewType
    let updateUIViewHandler: ((
        _ uiView: UIViewType,
        _ context: UIViewRepresentableContext<Self>
    ) -> Void)?

    /// Initialize the View Representable
    ///
    /// - Parameters:
    ///   - makeUIView: Creates a UIKit view configured with the provided information
    ///   - updateUIView: Update the current view base on the context
    public init(
        makeUIView: @escaping (
            _ context: UIViewRepresentableContext<Self>
        ) -> UIViewType,
        updateUIView: ((
            _ uiView: UIViewType,
            _ context: UIViewRepresentableContext<Self>
        ) -> Void
        )? = nil
    ) {
        makeUIViewHandler = makeUIView
        updateUIViewHandler = updateUIView
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        makeUIViewHandler(context)
    }

    public func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
        updateUIViewHandler?(uiView, context)
    }
}

#endif
