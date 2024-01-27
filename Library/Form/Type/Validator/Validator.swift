//
//  KindKit
//

import KindCore

public protocol Validator : Equatable {
    
    associatedtype Value : Equatable
    associatedtype Error : Swift.Error & Equatable
    
    func validate(value: Value) -> Error?
    
}
