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
    
    static let enabled = Api.RedirectOption(rawValue: 1 << 0)
    static let method = Api.RedirectOption(rawValue: 1 << 1)
    static let authorization = Api.RedirectOption(rawValue: 1 << 2)
    
}
