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

public extension CornerRadius.Edge {
    
    static let topLeft = CornerRadius.Edge(rawValue: 1 << 0)
    static let topRight = CornerRadius.Edge(rawValue: 1 << 1)
    static let bottomLeft = CornerRadius.Edge(rawValue: 1 << 2)
    static let bottomRight = CornerRadius.Edge(rawValue: 1 << 3)
    
    static let top: CornerRadius.Edge = [ .topLeft, .topRight ]
    static let left: CornerRadius.Edge = [ .topLeft, .bottomLeft ]
    static var right: CornerRadius.Edge = [ .topRight, .bottomRight ]
    static var bottom: CornerRadius.Edge = [ .bottomLeft, .bottomRight ]
    
    static var all: CornerRadius.Edge = [ .top, .bottom ]
    
}
