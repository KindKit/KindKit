//
//  KindKit
//

import KindEvent

public protocol IEntity : AnyObject {
    
    var status: Status { get }
    var observer: Observer< IObserver > { get }
    
    func request(source: Any) -> Bool
    
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
    func request() -> Bool {
        return self.request(source: self)
    }
    
}
