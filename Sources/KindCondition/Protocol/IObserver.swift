//
//  KindKit
//

public protocol IObserver : AnyObject {
    
    func changed(_ condition: IEntity)
    
}
