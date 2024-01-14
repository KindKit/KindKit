//
//  KindKit
//

public protocol IObserver : AnyObject {
    
    func redirectToSettings(_ permission: IEntity, source: Any?)
    func willRequest(_ permission: IEntity, source: Any?)
    func didRequest(_ permission: IEntity, source: Any?)
    
}

public extension IObserver {
    
    func redirectToSettings(_ permission: IEntity, source: Any?) {
    }
    
    func willRequest(_ permission: IEntity, source: Any?) {
    }
    
}
