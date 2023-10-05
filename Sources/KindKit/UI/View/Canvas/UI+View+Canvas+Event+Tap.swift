//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

extension UI.View.Canvas.Event {

    public struct Tap {
        
        public let gesture: UI.View.Canvas.Gesture
        public let location: Point
        
    }
    
}

#endif
