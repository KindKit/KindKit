//
//  KindKit
//

public protocol ResultTrait {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
}

extension Result : ResultTrait {
}
