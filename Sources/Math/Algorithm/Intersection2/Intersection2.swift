//
//  KindKitMath
//

import Foundation

public struct Intersection2< Value: IScalar & Hashable > {
}

public extension Intersection2 {
    
    struct Range : Equatable {
        
        public var lower: Value
        public var upper: Value
        
        public init(
            lower: Value,
            upper: Value
        ) {
            self.lower = lower
            self.upper = upper
        }
        
    }
    
}
