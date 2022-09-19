//
//  KindKit
//

#if swift(>=5.7) && os(iOS) && canImport(SwiftUI)

import UIKit
import SwiftUI

public extension UI.View {

    @available(iOS 13, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    struct Preview< View : IUIView > : UIViewRepresentable {
        
        private let view: View

        public init(_ view: View) {
            self.view = view
        }

        public func makeUIView(context: Context) -> some UIView {
            return self.view.native
        }

        public func updateUIView(_ uiView: UIViewType, context: Context) {
        }
        
    }
    
}

#endif

