//
//  KindKit
//

import Foundation

public extension UI.View.Scroll {
    
    struct Direction : OptionSet {
        
        public typealias RawValue = UInt
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension UI.View.Scroll.Direction {
    
    static var horizontal = Self(rawValue: 1 << 0)
    static var vertical = Self(rawValue: 1 << 1)
    
}
