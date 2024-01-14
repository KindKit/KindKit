//
//  KindKit
//

extension CompositionLayout.HStackPart {
    
    public struct Behaviour : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension CompositionLayout.HStackPart.Behaviour {
    
    static let fit = Self(rawValue: 1 << 0)
    
}
