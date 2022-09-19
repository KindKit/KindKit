//
//  KindKit
//

import Foundation

public extension Api {
    
    struct AuthenticationChallenge : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Api.AuthenticationChallenge {
    
    static var allowUntrusted = Api.AuthenticationChallenge(rawValue: 1 << 0)
    
}
