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

    func send< RequestType: IApiRequest, ResponseType: IApiResponse >(
        request: @autoclosure () throws -> RequestType,
        response: ResponseType,
        queue: DispatchQueue = DispatchQueue.main,
        completed: @escaping (_ response: ResponseType) -> Void
    ) -> IApiQuery {
        let query: IApiQuery
        if let request = try? request() {
            query = ApiTaskQuery< RequestType, ResponseType >(
                provider: self,
                request: request,
                response: response,
                queue: queue,
                onCompleted: completed
            )
        } else {
            query = ApiFailQuery< ResponseType >(
                provider: self,
                response: response,
                queue: queue,
                onCompleted: completed
            )
        }
        self.send(query: query)
        return query
    }

    func send< RequestType: IApiRequest, ResponseType: IApiResponse >(
        request: @autoclosure () throws -> RequestType,
        response: ResponseType,
        queue: DispatchQueue = DispatchQueue.main,
        download: @escaping (_ progress: Progress) -> Void,
        completed: @escaping (_ response: ResponseType) -> Void
    ) -> IApiQuery {
        let query: IApiQuery
        if let request = try? request() {
            query = ApiTaskQuery< RequestType, ResponseType >(
                provider: self,
                request: request,
                response: response,
                queue: queue,
                onDownload: download,
                onCompleted: completed
            )
        } else {
            query = ApiFailQuery< ResponseType >(
                provider: self,
                response: response,
                queue: queue,
                onCompleted: completed
            )
        }
        self.send(query: query)
        return query
    }

    func send< RequestType: IApiRequest, ResponseType: IApiResponse >(
        request: @autoclosure () throws -> RequestType,
        response: ResponseType,
        queue: DispatchQueue = DispatchQueue.main,
        upload: @escaping (_ progress: Progress) -> Void,
        completed: @escaping (_ response: ResponseType) -> Void
    ) -> IApiQuery {
        let query: IApiQuery
        if let request = try? request() {
            query = ApiTaskQuery< RequestType, ResponseType >(
                provider: self,
                request: request,
                response: response,
                queue: queue,
                onUpload: upload,
                onCompleted: completed
            )
        } else {
            query = ApiFailQuery< ResponseType >(
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
    
    func send< ResponseType: IApiResponse >(
        response: ResponseType,
        queue: DispatchQueue = DispatchQueue.main,
        prepare: @escaping () -> (http: HTTPURLResponse?, data: Data?, error: Error?),
        completed: @escaping (_ response: ResponseType) -> Void
    ) -> IApiQuery {
        let query = ApiMockQuery< ResponseType >(
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
