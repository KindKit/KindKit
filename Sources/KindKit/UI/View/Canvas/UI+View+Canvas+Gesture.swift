//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

extension UI.View.Canvas {

    public enum Gesture : CaseIterable {
        
        case one
        case two
        case three
        case four
        case five
        
    }
    
}

public extension UI.View.Canvas.Gesture {
    
    @inlinable
    var numberOfTouches: Int {
        switch self {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        }
    }
    
}

#endif
