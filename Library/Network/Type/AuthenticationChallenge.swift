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

extension AuthenticationChallenge : Hashable {
}

extension AuthenticationChallenge : Equatable {
}

extension AuthenticationChallenge : Sendable {
}

public extension AuthenticationChallenge {
    
    @inlinable
    static var allowUntrusted: Self {
        return .init(rawValue: 1 << 0)
    }
    
}
