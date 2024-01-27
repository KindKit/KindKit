//
//  KindKit
//

import Foundation

public extension CornerRadius {
    
    struct Edge : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

extension CornerRadius.Edge : Hashable {
}

extension CornerRadius.Edge : Equatable {
}

extension CornerRadius.Edge : Sendable {
}

public extension CornerRadius.Edge {
    
    @inlinable
    static var topLeft: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var topRight: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var bottomLeft: Self {
        return .init(rawValue: 1 << 2)
    }
    
    @inlinable
    static var bottomRight: Self {
        return .init(rawValue: 1 << 3)
    }
    
    @inlinable
    static var top: Self {
        return [ .topLeft, .topRight ]
    }
    
    @inlinable
    static var left: Self {
        return [ .topLeft, .bottomLeft ]
    }
    
    @inlinable
    static var right: Self {
        return [ .topRight, .bottomRight ]
    }
    
    @inlinable
    static var bottom: Self {
        return [ .bottomLeft, .bottomRight ]
    }
    
    @inlinable
    static var all: Self {
        return [ .top, .bottom ]
    }
    
}
