//
//  KindKit
//

import Foundation

public struct Intersection2 {
}

public extension Intersection2 {
    
    struct Range : Equatable {
        
        public var lower: Double
        public var upper: Double
        
        public init(
            lower: Double,
            upper: Double
        ) {
            self.lower = lower
            self.upper = upper
        }
        
    }
    
}
