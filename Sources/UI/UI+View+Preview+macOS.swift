//
//  KindKit
//

#if os(macOS) && canImport(SwiftUI)

import AppKit
import SwiftUI

public extension UI.View {

    @available(macOS 10.15, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    struct Preview< View : IUIView > : NSViewRepresentable {
        
        private let view: View

        public init(_ view: View) {
            self.view = view
        }

        public func makeNSView(context: Context) -> some NSView {
            return self.view.native
        }

        public func updateNSView(_ uiView: NSViewType, context: Context) {
        }
        
    }
    
}

#endif
