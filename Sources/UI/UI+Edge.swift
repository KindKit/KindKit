//
//  KindKit
//

import Foundation

public extension UI {
    
    struct Edge : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension UI.Edge {
    
    static let top = UI.Edge(rawValue: 1 << 0)
    static let left = UI.Edge(rawValue: 1 << 1)
    static let right = UI.Edge(rawValue: 1 << 2)
    static let bottom = UI.Edge(rawValue: 1 << 3)
    
}
