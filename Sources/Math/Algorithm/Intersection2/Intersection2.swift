//
//  KindKitMath
//

import Foundation

public struct Intersection2< ValueType: IScalar & Hashable > {
}

public extension Intersection2 {
    
    typealias BoxType = Box2< ValueType >
    typealias CircleType = Circle< ValueType >
    typealias LineType = Line2< ValueType >
    typealias PointType = Point< ValueType >
    typealias RangeType = Intersection2.Range
    typealias SegmentType = Segment2< ValueType >

}

public extension Intersection2 {
    
    struct Range : Equatable {
        
        public var lower: ValueType
        public var upper: ValueType
        
        public init(
            lower: ValueType,
            upper: ValueType
        ) {
            self.lower = lower
            self.upper = upper
        }
        
    }
    
}
