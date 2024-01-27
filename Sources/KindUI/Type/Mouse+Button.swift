//
//  KindKit
//

#if os(macOS)
import AppKit
#endif

extension Mouse {
    
    public enum Button : Equatable, Hashable {
        
        case primary
        case secondary
        case middle
        case other(UInt)
        
    }
    
}

public extension Mouse.Button {
    
    init(bit: UInt) {
        switch bit {
        case 1: self = .primary
        case 2: self = .secondary
        case 3: self = .middle
        default: self = .other(bit - 3)
        }
    }
    
}

public extension Mouse.Button {
    
    @inlinable
    var bitMask: UInt {
        switch self {
        case .primary: return 1 << 0
        case .secondary: return 1 << 1
        case .middle: return 1 << 2
        case .other(let index): return 1 << (3 + index)
        }
    }
    
    @inlinable
    var gestureDelayPrimary: Bool {
        return self == .primary
    }
    
    @inlinable
    var gestureDelaySecondary: Bool {
        return self == .secondary
    }
    
    @inlinable
    var gestureDelayOther: Bool {
        switch self {
        case .primary, .secondary: return false
        default: return true
        }
    }
    
}

#if os(macOS)

extension Array where Element == Mouse.Button {
    
    static func with(_ nsEvent: NSEvent) -> Self {
        var result: [Element] = []
        for bit in 0 ..< nsEvent.buttonMask.rawValue.bitWidth {
            result.append(.init(bit: .init(bit)))
        }
        return result
    }
    
    var nsButtonMask: NSEvent.ButtonMask {
        var result: NSEvent.ButtonMask = []
        for element in self {
            result.insert(.init(rawValue: element.bitMask))
        }
        return result
    }
    
}

#endif
