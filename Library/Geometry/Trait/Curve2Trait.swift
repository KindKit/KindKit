//
//  KindKit
//

import KindNumeric

public protocol Curve2Trait {
    
    var isSimple: Bool { get }

    var points: [Point] { get }
    var start: Point { set get }
    var end: Point { set get }
    var inverse: Self { get }
    var length: Distance { get }
    var squaredLength: SquaredDistance { get }
    var bbox: AlignedBox2 { get }
    
    func point(at location: Percent) -> Point
    func normal(at location: Percent) -> Point
    func offset(at: Percent, distance: Distance) -> Point
    func derivative(at location: Percent) -> Point
    
    func split(at location: Percent) -> (left: Self, right: Self)
    func cut(start: Percent, end: Percent) -> Self
    
}
