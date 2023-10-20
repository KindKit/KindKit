//
//  KindKit
//

import Foundation

extension UI.View.Canvas {

    public enum Gesture : CaseIterable {
        
#if os(macOS)
        case primary
        case secondary
        case middle
#elseif os(iOS)
        case one
        case two
        case three
        case four
        case five
#endif
        
    }
    
}

public extension UI.View.Canvas.Gesture {
    
#if os(macOS)
    
    @inlinable
    var mask: Int {
        switch self {
        case .primary: return 0x01
        case .secondary: return 0x02
        case .middle: return 0x04
        }
    }
    
#elseif os(iOS)
    
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
    
#endif
    
}
