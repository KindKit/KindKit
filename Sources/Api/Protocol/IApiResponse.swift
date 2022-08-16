//
//  KindKitApi
//

import Foundation

public protocol IApiResponse {
    
    associatedtype Success
    associatedtype Failure : Swift.Error
    
    typealias Result = Swift.Result< Success, Failure >

    func parse(meta: Api.Response.Meta, data: Data?) -> Result
    func parse(error: Error) -> Result
    
}
