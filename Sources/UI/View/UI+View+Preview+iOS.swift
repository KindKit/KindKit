//
//  KindKit
//

#if os(iOS) && targetEnvironment(simulator) && canImport(SwiftUI) && DEBUG

import UIKit
import SwiftUI

public extension UI.View {

    @available(iOS 13, tvOS 13.0, *)
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
