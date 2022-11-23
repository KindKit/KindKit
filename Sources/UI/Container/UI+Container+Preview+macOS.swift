//
//  KindKit
//

#if os(macOS) && canImport(SwiftUI) && DEBUG

import AppKit
import SwiftUI

public extension UI.Container {

    @available(macOS 10.15, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    struct Preview< Container : IUIContainer > : NSViewRepresentable {
        
        private let container: Container

        public init(_ container: Container) {
            self.container = container
        }

        public func makeNSView(context: Context) -> some NSView {
            let view = self.container.view.native
            self.container.prepareShow(interactive: false)
            self.container.finishShow(interactive: false)
            return view
        }

        public func updateNSView(_ uiView: NSViewType, context: Context) {
        }
        
    }
    
}

#endif
