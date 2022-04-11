//
//  KindKitMath
//

import Foundation

public struct Closest2< ValueType: IScalar & Hashable > {
}

public extension Closest2 {
    
    typealias BoxType = Box2< ValueType >
    typealias CircleType = Circle< ValueType >
    typealias LineType = Line2< ValueType >
    typealias PointType = Point< ValueType >
    typealias SegmentType = Segment2< ValueType >
    typealias CubicCurveType = CubicCurve2< ValueType >
    typealias QuadCurveType = QuadCurve2< ValueType >

}
