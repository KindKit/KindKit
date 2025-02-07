//
//  KindKit
//

import Foundation

public extension Log.Message {
    
    struct Options : OptionSet {
        
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Log.Message.Options {
    
    static let pretty = Self(rawValue: 1 << 0)
    static let allowSecureInfo = Self(rawValue: 1 << 1)
    
}
