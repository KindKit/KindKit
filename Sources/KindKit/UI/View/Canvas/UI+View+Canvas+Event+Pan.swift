//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

extension UI.View.Canvas.Event {

    public struct Pan {
        
        public let gesture: UI.View.Canvas.Gesture
        public let state: UI.View.Canvas.Gesture.State
        public let location: Point
        
    }
    
}

#endif
