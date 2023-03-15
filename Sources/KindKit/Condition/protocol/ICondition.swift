//
//  KindKit
//

import Foundation

public protocol ICondition : AnyObject {
    
    var observer: Observer< IConditionObserver > { get }
    
    func refresh()

    func callAsFunction() -> Bool
    
}

public extension ICondition {
    
    @inlinable
    func add(observer: IConditionObserver, priority: ObserverPriority) {
        self.observer.add(observer, priority: priority)
    }
    
    @inlinable
    func remove(observer: IConditionObserver) {
        self.observer.remove(observer)
    }
    
    @inlinable
    func notifyChanged() {
        self.observer.notify({ $0.changed(self) })
    }
    
}
