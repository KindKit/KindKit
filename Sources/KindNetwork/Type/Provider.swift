//
//  KindKit
//

import Foundation

public final class Provider {
    
    public var url: URL?
    public var headers: [Request.Header]
    public var authenticationChallenge: AuthenticationChallenge {
        set { self._sessionDelegate.authenticationChallenge = newValue }
        get { self._sessionDelegate.authenticationChallenge }
    }
    public var localCertificateUrls: [URL] {
        set { self._sessionDelegate.localCertificateUrls = newValue }
        get { self._sessionDelegate.localCertificateUrls }
    }
    public var logging: Logging

    private var _session: URLSession!
    private let _sessionDelegate: SessionDelegate

    public init(
        url: URL? = nil,
        headers: [Request.Header] = [],
        authenticationChallenge: AuthenticationChallenge = [],
        localCertificateUrls: [URL] = [],
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        logging: Logging = .never
    ) {
        self.url = url
        self.headers = headers
        self.logging = logging
        self._sessionDelegate = .init(
            authenticationChallenge: authenticationChallenge,
            localCertificateUrls: localCertificateUrls
        )
        self._session = URLSession(
            configuration: configuration,
            delegate: self._sessionDelegate,
            delegateQueue: OperationQueue()
        )
    }
    
    deinit {
        self._session.invalidateAndCancel()
    }
    
    public func send< Response : IResponse >(
        request: @autoclosure @escaping () throws -> Request,
        response: Response,
        queue: DispatchQueue,
        completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
    ) -> ICancellable {
        do {
            let request = try request()
            let query = try Query.Task(provider: self, session: self._session, request: request, response: response, queue: queue, onCompleted: completed)
            self._sessionDelegate.append(query)
            return query
        } catch let error as Error.Request {
            return Query.Fail(provider: self, error: error, response: response, queue: queue, onCompleted: completed)
        } catch let error {
            return Query.Fail(provider: self, error: .unhandle(error), response: response, queue: queue, onCompleted: completed)
        }
    }
    
    public func send< Response : IResponse >(
        request: @autoclosure @escaping () throws -> Request,
        response: Response,
        queue: DispatchQueue,
        download: @escaping (_ progress: Progress) -> Void,
        completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
    ) -> ICancellable {
        do {
            let request = try request()
            let query = try Query.Task(provider: self, session: self._session, request: request, response: response, queue: queue, onDownload: download, onCompleted: completed)
            self._sessionDelegate.append(query)
            return query
        } catch let error as Error.Request {
            return Query.Fail(provider: self, error: error, response: response, queue: queue, onCompleted: completed)
        } catch let error {
            return Query.Fail(provider: self, error: .unhandle(error), response: response, queue: queue, onCompleted: completed)
        }
    }
    
    public func send< Response : IResponse >(
        request: @autoclosure @escaping () throws -> Request,
        response: Response,
        queue: DispatchQueue,
        upload: @escaping (_ progress: Progress) -> Void,
        completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
    ) -> ICancellable {
        do {
            let request = try request()
            let query = try Query.Task(provider: self, session: self._session, request: request, response: response, queue: queue, onUpload: upload, onCompleted: completed)
            self._sessionDelegate.append(query)
            return query
        } catch let error as Error.Request {
            return Query.Fail(provider: self, error: error, response: response, queue: queue, onCompleted: completed)
        } catch let error {
            return Query.Fail(provider: self, error: .unhandle(error), response: response, queue: queue, onCompleted: completed)
        }
    }
    
}
