//
//  KindKit
//

import Foundation

public protocol IApiProvider : AnyObject {

    var url: URL? { get }
    var headers: [Api.Request.Header] { get }
    var logging: Api.Logging { get }

    func send< Response : IApiResponse >(
        request: @autoclosure @escaping () throws -> Api.Request?,
        response: Response,
        queue: DispatchQueue,
        completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
    ) -> ICancellable
    
    func send< Response : IApiResponse >(
        request: @autoclosure @escaping () throws -> Api.Request?,
        response: Response,
        queue: DispatchQueue,
        download: @escaping (_ progress: Progress) -> Void,
        completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
    ) -> ICancellable
    
    func send< Response : IApiResponse >(
        request: @autoclosure @escaping () throws -> Api.Request?,
        response: Response,
        queue: DispatchQueue,
        upload: @escaping (_ progress: Progress) -> Void,
        completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
    ) -> ICancellable

}
