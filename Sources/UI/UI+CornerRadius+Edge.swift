//
//  KindKit
//

import Foundation

public extension UI.CornerRadius {
    
    struct Edge : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension UI.CornerRadius.Edge {
    
    static let topLeft = UI.CornerRadius.Edge(rawValue: 1 << 0)
    static let topRight = UI.CornerRadius.Edge(rawValue: 1 << 1)
    static let bottomLeft = UI.CornerRadius.Edge(rawValue: 1 << 2)
    static let bottomRight = UI.CornerRadius.Edge(rawValue: 1 << 3)
    
    static let top: UI.CornerRadius.Edge = [ .topLeft, .topRight ]
    static let left: UI.CornerRadius.Edge = [ .topLeft, .bottomLeft ]
    static var right: UI.CornerRadius.Edge = [ .topRight, .bottomRight ]
    static var bottom: UI.CornerRadius.Edge = [ .bottomLeft, .bottomRight ]
    
    static var all: UI.CornerRadius.Edge = [ .top, .bottom ]
    
}
