//
//  KindKit
//

import Foundation

public protocol IDataSource : ICancellable {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
    typealias Result = Swift.Result< Success, Failure >
    
    var result: Result? { get }
    var onFinish: Signal.Args< Void, Result > { get }
    
}
