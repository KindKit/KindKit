//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public protocol FiniteTimer : Timer {
    
    var isFinished: Bool { get }
    
    @MonadicSignal
    var onFinished: Signal< Void, Void > { get }
    
}
