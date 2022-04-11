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
    typealias RangeType = Range< ValueType >
    typealias SegmentType = Segment2< ValueType >

}
