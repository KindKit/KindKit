//
//  KindKit
//

import Foundation

public protocol IApiResponse {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
    typealias Result = Swift.Result< Success, Failure >
    
    func logging(provider: Api.Provider, result: Result) -> Api.Logging

    func parse(meta: Api.Response.Meta, data: Data?) -> Result
    func parse(error: Error) -> Result
    
}

public extension IApiResponse {
    
    func logging(provider: Api.Provider, result: Result) -> Api.Logging {
        return provider.logging
    }
    
    @inlinable
    func hasRequest(error: Error) -> Api.Error.Request? {
        return error as? Api.Error.Request
    }

    @inlinable
    func hasNetwork(error: Error) -> Api.Error.Network? {
        if let error = error as? Api.Error.Network {
            return error
        }
        return Api.Error.Network(error as NSError)
    }
    
}
