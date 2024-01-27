//
//  KindKit
//

public struct Options : OptionSet {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}

extension Options : Hashable {
}

extension Options : Equatable {
}

extension Options : Sendable {
}

public extension Options {
    
    @inlinable
    static var inline: Self {
        return .init(rawValue: 1 << 0)
    }
    
}
