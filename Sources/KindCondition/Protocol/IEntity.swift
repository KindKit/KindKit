//
//  KindKit
//

import KindEvent

public protocol IEntity : AnyObject {
    
    var observer: Observer< IObserver > { get }
    
    func refresh()

    func callAsFunction() -> Bool
    
}

public extension IEntity {
    
    @inlinable
    func add(observer: IObserver, priority: KindEvent.Priority) {
        self.observer.add(observer, priority: priority)
    }
    
    @inlinable
    func remove(observer: IObserver) {
        self.observer.remove(observer)
    }
    
    @inlinable
    func notifyChanged() {
        self.observer.emit({ $0.changed(self) })
    }
    
}
