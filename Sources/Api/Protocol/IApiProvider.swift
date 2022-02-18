//
//  KindKitApi
//

import Foundation

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
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue = DispatchQueue.main,
        completed: @escaping ApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> ApiTaskQuery< RequestType, ResponseType > {
        let query = ApiTaskQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            onCompleted: completed
        )
        self.send(query: query)
        return query
    }

    func send< RequestType: IApiRequest, ResponseType: IApiResponse >(
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue = DispatchQueue.main,
        download: @escaping ApiTaskQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping ApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> ApiTaskQuery< RequestType, ResponseType > {
        let query = ApiTaskQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            onDownload: download,
            onCompleted: completed
        )
        self.send(query: query)
        return query
    }

    func send< RequestType: IApiRequest, ResponseType: IApiResponse >(
        request: RequestType,
        response: ResponseType,
        queue: DispatchQueue = DispatchQueue.main,
        upload: @escaping ApiTaskQuery< RequestType, ResponseType >.ProgressClosure,
        completed: @escaping ApiTaskQuery< RequestType, ResponseType >.CompleteClosure
    ) -> ApiTaskQuery< RequestType, ResponseType > {
        let query = ApiTaskQuery< RequestType, ResponseType >(
            provider: self,
            request: request,
            response: response,
            queue: queue,
            onUpload: upload,
            onCompleted: completed
        )
        self.send(query: query)
        return query
    }
    
}

public extension IApiProvider {
    
    func send< ResponseType: IApiResponse >(
        response: ResponseType,
        queue: DispatchQueue = DispatchQueue.main,
        prepare: @escaping ApiMockQuery< ResponseType >.PrepareClosure,
        completed: @escaping ApiMockQuery< ResponseType >.CompleteClosure
    ) -> ApiMockQuery<  ResponseType > {
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
