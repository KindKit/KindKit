//
//  KindKit
//

import Foundation

public protocol IBackgroundManagerObserver : AnyObject {

    func expiredSession(_ manager: IBackgroundManager)

}

public protocol IBackgroundManager : AnyObject {
    
    var observer: Observer< IBackgroundManagerObserver > { get }
    
    func start()
    func stop()

}

public extension IBackgroundManager {
    
    @inlinable
    func add(observer: IBackgroundManagerObserver, priority: ObserverPriority) {
        self.observer.add(observer, priority: priority)
    }
    
    @inlinable
    func remove(observer: IBackgroundManagerObserver) {
        self.observer.remove(observer)
    }
    
}
