//
//  KindKit
//

import Foundation

public protocol ICurve2 {
    
    var isSimple: Bool { get }

    var points: [Point] { get }
    var start: Point { set get }
    var end: Point { set get }
    var inverse: Self { get }
    var length: Distance { get }
    var bbox: AlignedBox2 { get }
    
    func point(at location: Percent) -> Point
    func normal(at location: Percent) -> Point
    func derivative(at location: Percent) -> Point
    
    func split(at location: Percent) -> (left: Self, right: Self)
    func cut(start: Percent, end: Percent) -> Self
    
}

public extension ICurve2 {
    
    @inlinable
    func offset(at: Percent, distance: Distance) -> Point {
        let point = self.point(at: at)
        let normal = self.normal(at: at)
        return point + distance * normal
    }
    
}
