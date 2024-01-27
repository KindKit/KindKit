//
//  KindKit
//

import Foundation

public protocol Response {
    
    associatedtype Success : Sendable
    associatedtype Failure : Swift.Error & Sendable
    
    typealias Result = Swift.Result< Success, Failure >
    
    func logging(provider: Provider, result: Result) -> Logging

    func parse(meta: MetaResponse, data: Data?) -> Result
    func parse(error: Swift.Error) -> Result
    
}

public extension Response {
    
    func logging(provider: Provider, result: Result) -> Logging {
        return provider.logging
    }
    
    @inlinable
    func hasRequest(error: Swift.Error) -> RequestError? {
        return error as? RequestError
    }

    @inlinable
    func hasNetwork(error: Swift.Error) -> NetworkError? {
        if let error = error as? NetworkError {
            return error
        }
        return NetworkError(error as NSError)
    }
    
}
