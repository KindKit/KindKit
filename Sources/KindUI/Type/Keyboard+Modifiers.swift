//
//  KindKit
//

#if os(macOS)
import AppKit
#endif

extension Keyboard {
    
    public struct Modifiers : OptionSet, Hashable {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Keyboard.Modifiers {
    
    static let shift = Self(rawValue: 1 << 0)
    static let control = Self(rawValue: 1 << 1)
    static let option = Self(rawValue: 1 << 2)
    static let command = Self(rawValue: 1 << 3)
    static let function = Self(rawValue: 1 << 4)
    
    static let capsLock = Self(rawValue: 1 << 7)
    static let numericPad = Self(rawValue: 1 << 8)
    
}

#if os(macOS)

public extension Keyboard.Modifiers {
    
    static func with(flags: NSEvent.ModifierFlags) -> Self {
        var result = Self()
        if flags.contains(.shift) == true {
            result.insert(.shift)
        }
        if flags.contains(.control) == true {
            result.insert(.control)
        }
        if flags.contains(.option) == true {
            result.insert(.option)
        }
        if flags.contains(.command) == true {
            result.insert(.command)
        }
        if flags.contains(.function) == true {
            result.insert(.function)
        }
        if flags.contains(.capsLock) == true {
            result.insert(.capsLock)
        }
        if flags.contains(.numericPad) == true {
            result.insert(.numericPad)
        }
        return result
    }
    
    var flags: NSEvent.ModifierFlags {
        var result = NSEvent.ModifierFlags()
        if self.contains(.shift) == true {
            result.insert(.shift)
        }
        if self.contains(.control) == true {
            result.insert(.control)
        }
        if self.contains(.option) == true {
            result.insert(.option)
        }
        if self.contains(.command) == true {
            result.insert(.command)
        }
        if self.contains(.function) == true {
            result.insert(.function)
        }
        if self.contains(.capsLock) == true {
            result.insert(.capsLock)
        }
        if self.contains(.numericPad) == true {
            result.insert(.numericPad)
        }
        return result
    }
    
}

#endif
