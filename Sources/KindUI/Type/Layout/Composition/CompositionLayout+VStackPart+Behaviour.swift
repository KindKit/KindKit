//
//  KindKit
//

extension CompositionLayout.VStackPart {
    
    public struct Behaviour : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension CompositionLayout.VStackPart.Behaviour {
    
    static let fit = Self(rawValue: 1 << 0)
    
}
