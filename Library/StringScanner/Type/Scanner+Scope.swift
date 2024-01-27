//
//  KindKit
//

extension Scanner {
    
    public struct Scope : OptionSet, Sendable {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Scanner.Scope {
    
    @inlinable
    static var restoreAfterException: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var restoreAfterFinish: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var restoreAlways: Self {
        return [ .restoreAfterException, .restoreAfterFinish ]
    }
    
}
