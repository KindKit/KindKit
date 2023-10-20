//
//  KindKit
//

import Foundation

extension UI.Gesture {
    
    public enum Buttons {
        
        case primary
        case secondary
        case middle
        
    }
    
}

extension UI.Gesture.Buttons {
    
    @inlinable
    var mask: Int {
        switch self {
        case .primary: return 0x01
        case .secondary: return 0x02
        case .middle: return 0x04
        }
    }
    
    @inlinable
    var delayPrimary: Bool {
        return self == .primary
    }
    
    @inlinable
    var delaySecondary: Bool {
        return self == .secondary
    }
    
    @inlinable
    var delayOther: Bool {
        switch self {
        case .primary, .secondary: return false
        default: return true
        }
    }
    
}
