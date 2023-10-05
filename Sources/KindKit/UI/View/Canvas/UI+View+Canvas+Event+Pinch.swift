//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

extension UI.View.Canvas.Event {

    public struct Pinch {
        
        public let state: UI.View.Canvas.Gesture.State
        public let location: Point
        public let scale: Double
        
    }
    
}

#endif
