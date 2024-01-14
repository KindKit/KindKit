//
//  KindKit
//

extension ScrollView {
    
    public struct Bounce : OptionSet {
        
        public typealias RawValue = UInt
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension ScrollView.Bounce {
    
    static var horizontal = Self(rawValue: 1 << 0)
    static var vertical = Self(rawValue: 1 << 1)
    static var zoom = Self(rawValue: 1 << 2)
    
}
