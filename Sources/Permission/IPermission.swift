//
//  KindKitPermission
//

import Foundation
import KindKitObserver

public enum PermissionStatus {
    case notSupported
    case notDetermined
    case authorized
    case denied
}

public protocol IPermission : AnyObject {
    
    var status: PermissionStatus { get }
    
    func add(observer: IPermissionObserver, priority: ObserverPriority)
    func remove(observer: IPermissionObserver)
    
    func request(source: Any)
    
}

public protocol IPermissionObserver : AnyObject {
    
    func didRedirectToSettings(_ permission: IPermission, source: Any?)
    func willRequest(_ permission: IPermission, source: Any?)
    func didRequest(_ permission: IPermission, source: Any?)
    
}
