//
//  KindKit
//

import Foundation

public struct AuthenticationChallenge : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension AuthenticationChallenge {
    
    static var allowUntrusted = AuthenticationChallenge(rawValue: 1 << 0)
    
}
