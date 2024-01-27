//
//  KindKit
//

public protocol TrigonometricTrait {
    
    static var pi: Self { get }
    
    var sin: Self { get }
    
    var asin: Self { get }
    
    var cos: Self { get }
    
    var acos: Self { get }
    
    var tan: Self { get }
    
    var atan: Self { get }
    
    func atan2(_ other: Self) -> Self
    
}
