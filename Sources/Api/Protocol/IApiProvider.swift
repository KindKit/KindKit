//
//  KindKitApi
//

import Foundation
import KindKitCore

public protocol IApiProvider : AnyObject {

    var url: URL? { get }
    var queryParams: [String: Any] { get }
    var headers: [String: String] { get }
    var bodyParams: [String: Any]? { get }
    #if DEBUG
    var logging: ApiLogging { get }
    #endif

    func send(query: IApiQuery)

}

public extension IApiProvider {

    func send< Request : IApiRequest, Response : IApiResponse >(
        request: @autoclosure () throws -> Request,
        response: Response,
        queue: DispatchQueue = DispatchQueue.main,
        completed: @escaping (_ response: Response) -> Void
    ) -> IApiQuery {
        let query: IApiQuery
        if let request = try? request() {
            query = ApiTaskQuery< Request, Response >(
                provider: self,
                request: request,
                response: response,
                queue: queue,
                onCompleted: completed
            )
        } else {
            query = ApiFailQuery< Response >(
                provider: self,
                response: response,
                queue: queue,
                onCompleted: completed
            )
        }
        self.send(query: query)
        return query
    }

    func send< Request : IApiRequest, Response : IApiResponse >(
        request: @autoclosure () throws -> Request,
        response: Response,
        queue: DispatchQueue = DispatchQueue.main,
        download: @escaping (_ progress: Progress) -> Void,
        completed: @escaping (_ response: Response) -> Void
    ) -> IApiQuery {
        let query: IApiQuery
        if let request = try? request() {
            query = ApiTaskQuery< Request, Response >(
                provider: self,
                request: request,
                response: response,
                queue: queue,
                onDownload: download,
                onCompleted: completed
            )
        } else {
            query = ApiFailQuery< Response >(
                provider: self,
                response: response,
                queue: queue,
                onCompleted: completed
            )
        }
        self.send(query: query)
        return query
    }

    func send< Request : IApiRequest, Response : IApiResponse >(
        request: @autoclosure () throws -> Request,
        response: Response,
        queue: DispatchQueue = DispatchQueue.main,
        upload: @escaping (_ progress: Progress) -> Void,
        completed: @escaping (_ response: Response) -> Void
    ) -> IApiQuery {
        let query: IApiQuery
        if let request = try? request() {
            query = ApiTaskQuery< Request, Response >(
                provider: self,
                request: request,
                response: response,
                queue: queue,
                onUpload: upload,
                onCompleted: completed
            )
        } else {
            query = ApiFailQuery< Response >(
                provider: self,
                response: response,
                queue: queue,
                onCompleted: completed
            )
        }
        self.send(query: query)
        return query
    }
    
}

public extension IApiProvider {
    
    func send< Response : IApiResponse >(
        response: Response,
        queue: DispatchQueue = DispatchQueue.main,
        prepare: @escaping () -> (http: HTTPURLResponse?, data: Data?, error: Error?),
        completed: @escaping (_ response: Response) -> Void
    ) -> IApiQuery {
        let query = ApiMockQuery< Response >(
            provider: self,
            response: response,
            queue: queue,
            onPrepare: prepare,
            onCompleted: completed
        )
        self.send(query: query)
        return query
    }
    
}
