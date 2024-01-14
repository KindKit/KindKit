//
//  KindKit
//

public protocol IResult {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
}

extension Result : IResult {
}
