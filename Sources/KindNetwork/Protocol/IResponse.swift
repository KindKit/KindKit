//
//  KindKit
//

import Foundation

public protocol IResponse {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
    typealias Result = Swift.Result< Success, Failure >
    
    func logging(provider: Provider, result: Result) -> Logging

    func parse(meta: Response.Meta, data: Data?) -> Result
    func parse(error: Swift.Error) -> Result
    
}

public extension IResponse {
    
    func logging(provider: Provider, result: Result) -> Logging {
        return provider.logging
    }
    
    @inlinable
    func hasRequest(error: Swift.Error) -> Error.Request? {
        return error as? Error.Request
    }

    @inlinable
    func hasNetwork(error: Swift.Error) -> Error.Network? {
        if let error = error as? Error.Network {
            return error
        }
        return Error.Network(error as NSError)
    }
    
}
