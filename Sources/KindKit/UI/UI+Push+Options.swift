//
//  KindKit
//

import Foundation

public extension UI.Push {
    
    struct Options : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension UI.Push.Options {
    
    static let useContentInset = UI.Push.Options(rawValue: 1 << 0)
    
}
