//
//  KindKit
//

extension Scanner {
    
    public struct Scope : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Scanner.Scope {
    
    static let restoreAfterException = Self(rawValue: 1 << 0)
    static let restoreAfterFinish = Self(rawValue: 1 << 1)
    
    static let restoreAlways: Self = [ .restoreAfterException, .restoreAfterFinish ]
    
}
