//
//  KindKit
//

import Foundation

public extension Message {
    
    struct Options : OptionSet {
        
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Message.Options {
    
    static let pretty = Self(rawValue: 1 << 0)
    
}
