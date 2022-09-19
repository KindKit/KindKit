//
//  KindKit
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public protocol ICurve2 {
    
    associatedtype Value : IScalar & Hashable
    
    var isSimple: Bool { get }

    var points: [Point< Value >] { get }
    var start: Point< Value > { set get }
    var end: Point< Value > { set get }
    var inverse: Self { get }
    var length: Distance< Value > { get }
    var bbox: Box2< Value > { get }
    
    func point(at location: Percent< Value >) -> Point< Value >
    func normal(at location: Percent< Value >) -> Point< Value >
    func derivative(at location: Percent< Value >) -> Point< Value >
    
    func split(at location: Percent< Value >) -> (left: Self, right: Self)
    func cut(start: Percent< Value >, end: Percent< Value >) -> Self
    
}

public extension ICurve2 {
    
    @inlinable
    func offset(at: Percent< Value >, distance: Value) -> Point< Value > {
        let point = self.point(at: at)
        let normal = self.normal(at: at)
        return point + distance * normal
    }
    
}
