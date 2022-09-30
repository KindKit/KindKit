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
    
    static let top: UI.CornerRadius.Edge = [ .topLeft, .topRight ]
    static let topLeft = UI.CornerRadius.Edge(rawValue: 1 << 0)
    static let topRight = UI.CornerRadius.Edge(rawValue: 1 << 1)
    
    static var bottom: UI.CornerRadius.Edge = [ .bottomLeft, .bottomRight ]
    static let bottomLeft = UI.CornerRadius.Edge(rawValue: 1 << 2)
    static let bottomRight = UI.CornerRadius.Edge(rawValue: 1 << 3)
    
    static var all: UI.CornerRadius.Edge = [ .top, .bottom ]
    
}
