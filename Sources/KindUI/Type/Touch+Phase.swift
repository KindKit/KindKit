//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

extension Touch {
    
    public enum Phase : Equatable, Hashable {
        
        case began
        case moved
        case stationary
        case ended
        case cancelled
        
    }
    
}

public extension Touch.Phase {
    
    @inlinable
    var isTouching: Bool {
        switch self {
        case .began, .moved, .stationary: return true
        case .ended, .cancelled: return false
        }
    }
    
    @inlinable
    var isFinished: Bool {
        switch self {
        case .began, .moved, .stationary: return false
        case .ended, .cancelled: return true
        }
    }
    
#if os(macOS)
    
    static func with(_ phase: NSTouch.Phase) -> Self? {
        switch phase {
        case .began: return .began
        case .moved: return .moved
        case .stationary: return .stationary
        case .ended: return .ended
        case .cancelled: return .cancelled
        default: return nil
        }
    }
#elseif os(iOS)
    
    static func with(_ phase: UITouch.Phase) -> Self? {
        switch phase {
        case .began: return .began
        case .moved: return .moved
        case .stationary: return .stationary
        case .ended: return .ended
        case .cancelled: return .cancelled
        default: return nil
        }
    }
    
#endif
    
}
