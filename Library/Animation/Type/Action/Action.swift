//
//  KindKit
//

import KindEvent
import KindMeasure
import KindMonadicMacro

@Monadic
public protocol Action : CancelTrait {
    
    var state: State { get }
    
    @MonadicSignal
    var onStart: Signal< Void, Void > { get }
    
    @MonadicSignal
    var onFinish: Signal< Void, Bool > { get }
    
    func update(_ time: Time) -> Result
    
}
