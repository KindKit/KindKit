//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public protocol Base : CancelTrait {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
    typealias Result = Swift.Result< Success, Failure >
    
    var result: Result? { get }
    
    @MonadicSignal
    var onFinish: Signal< Void, Result > { get }
    
}
