//
//  KindKitMath
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public protocol ICurve2 {
    
    associatedtype ValueType: IScalar & Hashable
    
    var isSimple: Bool { get }

    var points: [Point< ValueType >] { get }
    var start: Point< ValueType > { set get }
    var end: Point< ValueType > { set get }
    var inverse: Self { get }
    var length: Distance< ValueType > { get }
    var bbox: Box2< ValueType > { get }
    
    func point(at location: Percent< ValueType >) -> Point< ValueType >
    func normal(at location: Percent< ValueType >) -> Point< ValueType >
    func derivative(at location: Percent< ValueType >) -> Point< ValueType >
    
    func split(at location: Percent< ValueType >) -> (left: Self, right: Self)
    func cut(start: Percent< ValueType >, end: Percent< ValueType >) -> Self
    
}

public extension ICurve2 {
    
    @inlinable
    func offset(at: Percent< ValueType >, distance: ValueType) -> Point< ValueType > {
        let point = self.point(at: at)
        let normal = self.normal(at: at)
        return point + distance * normal
    }
    
}
