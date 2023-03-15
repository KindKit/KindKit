//
//  KindKit
//

import Foundation

public protocol IPermission : AnyObject {
    
    var status: Permission.Status { get }
    
    func add(observer: IPermissionObserver, priority: ObserverPriority)
    func remove(observer: IPermissionObserver)
    
    func request(source: Any)
    
}

public extension IPermission {
    
    func request() {
        self.request(source: self)
    }
    
}

public protocol IPermissionObserver : AnyObject {
    
    func didRedirectToSettings(_ permission: IPermission, source: Any?)
    func willRequest(_ permission: IPermission, source: Any?)
    func didRequest(_ permission: IPermission, source: Any?)
    
}

public extension IPermissionObserver {
    
    func didRedirectToSettings(_ permission: IPermission, source: Any?) {
    }
    
    func willRequest(_ permission: IPermission, source: Any?) {
    }
    
}
