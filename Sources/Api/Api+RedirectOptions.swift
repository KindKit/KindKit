//
//  KindKit
//

import Foundation

public extension Api {
    
    struct RedirectOption : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Api.RedirectOption {
    
    static var enabled = Api.RedirectOption(rawValue: 1 << 0)
    static var method = Api.RedirectOption(rawValue: 1 << 1)
    static var authorization = Api.RedirectOption(rawValue: 1 << 2)
    
}
