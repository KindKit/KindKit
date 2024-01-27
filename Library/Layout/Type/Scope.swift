//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public protocol Scope : AnyObject, BatchUpdateTrait {
    
    @MonadicSignal
    var onLockUpdate: Signal< Void, Void > { get }
    
    @MonadicSignal
    var onUnlockUpdate: Signal< Void, Void > { get }
    
    @MonadicSignal
    var onInvalidate: Signal< Bool?, Void > { get }
    
    @MonadicSignal
    var onContentSize: Signal< Void, Void > { get }
    
    func invalidate()
    
    func remove(_ item: any Item)
    
}
