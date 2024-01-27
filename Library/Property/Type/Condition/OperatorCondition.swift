//
//  KindKit
//

import KindMonadicMacro

@Monadic
public protocol OperatorCondition : Condition {
    
    associatedtype Left: Property
    associatedtype Right: Property
    
    @MonadicField
    var left: Left { set get }
    
    @MonadicField
    var right: Right { set get }
    
}
