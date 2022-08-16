//
//  KindKitApi
//

import Foundation
import KindKitCore

public extension Api {
    
    final class Provider : NSObject, IApiProvider {

        public var url: URL?
        public var headers: [Api.Request.Header]
        public var authenticationChallenge: AuthenticationChallenge
        public var localCertificateUrls: [URL]
        #if DEBUG
        public var logging: Api.Logging = .never
        #endif

        public var session: URLSession!
        
        private var _queue: DispatchQueue
        private var _tasks: [Int : IApiTaskQuery]

        public init(
            url: URL? = nil,
            headers: [Api.Request.Header] = [],
            bodyParams: [String: Any]? = nil,
            authenticationChallenge: AuthenticationChallenge = [],
            localCertificateUrls: [URL] = [],
            configuration: URLSessionConfiguration = URLSessionConfiguration.default
        ) {
            self.url = url
            self.headers = headers
            self.authenticationChallenge = authenticationChallenge
            self.localCertificateUrls = localCertificateUrls
            self._queue = DispatchQueue(label: "KindKitApi.Api.Provider")
            self._tasks = [:]
            super.init()
            self.session = URLSession(
                configuration: configuration,
                delegate: self,
                delegateQueue: OperationQueue()
            )
        }
        
        public func send< Response : IApiResponse >(
            request: @autoclosure @escaping () throws -> Api.Request?,
            response: Response,
            queue: DispatchQueue,
            completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
        ) -> ICancellable {
            do {
                if let request = try request() {
                    let query = try Api.Query.Task(provider: self, session: self.session, request: request, response: response, queue: queue, onCompleted: completed)
                    self._queue.sync(flags: .barrier, execute: {
                        self._tasks[query.task.taskIdentifier] = query
                    })
                    return query
                }
            } catch {
            }
            return Api.Query.Fail(provider: self, response: response, queue: queue, onCompleted: completed)
        }
        
        public func send< Response : IApiResponse >(
            request: @autoclosure @escaping () throws -> Api.Request?,
            response: Response,
            queue: DispatchQueue,
            download: @escaping (_ progress: Progress) -> Void,
            completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
        ) -> ICancellable {
            do {
                if let request = try request() {
                    let query = try Api.Query.Task(provider: self, session: self.session, request: request, response: response, queue: queue, onDownload: download, onCompleted: completed)
                    self._queue.sync(flags: .barrier, execute: {
                        self._tasks[query.task.taskIdentifier] = query
                    })
                    return query
                }
            } catch {
            }
            return Api.Query.Fail(provider: self, response: response, queue: queue, onCompleted: completed)
        }
        
        public func send< Response : IApiResponse >(
            request: @autoclosure @escaping () throws -> Api.Request?,
            response: Response,
            queue: DispatchQueue,
            upload: @escaping (_ progress: Progress) -> Void,
            completed: @escaping (_ response: Result< Response.Success, Response.Failure >) -> Void
        ) -> ICancellable {
            do {
                if let request = try request() {
                    let query = try Api.Query.Task(provider: self, session: self.session, request: request, response: response, queue: queue, onUpload: upload, onCompleted: completed)
                    self._queue.sync(flags: .barrier, execute: {
                        self._tasks[query.task.taskIdentifier] = query
                    })
                    return query
                }
            } catch {
            }
            return Api.Query.Fail(provider: self, response: response, queue: queue, onCompleted: completed)
        }
        
    }
    
}

private extension Api.Provider {
    
    func _query(task: URLSessionTask) -> IApiTaskQuery? {
        var query: IApiTaskQuery? = nil
        self._queue.sync {
            query = self._tasks[task.taskIdentifier]
        }
        return query
    }
    
    func _remove(task: URLSessionTask) -> IApiTaskQuery? {
        var query: IApiTaskQuery? = nil
        self._queue.sync {
            let key = task.taskIdentifier
            query = self._tasks[key]
            self._tasks.removeValue(forKey: key)
        }
        return query
    }
    
    func _move(fromTask: URLSessionTask, toTask: URLSessionTask) -> IApiTaskQuery? {
        var query: IApiTaskQuery? = nil
        self._queue.sync {
            query = self._tasks[fromTask.taskIdentifier]
            self._tasks.removeValue(forKey: fromTask.taskIdentifier)
            if let query = query {
                self._tasks[toTask.taskIdentifier] = query
            }
        }
        return query
    }
    
    func _authentication(challenge: URLAuthenticationChallenge) -> (disposition: URLSession.AuthChallengeDisposition, credential: URLCredential?) {
        guard let trust = challenge.protectionSpace.serverTrust else {
            return (disposition: .performDefaultHandling, credential: nil)
        }
        if self.authenticationChallenge.contains(.allowUntrusted) == true {
            return (disposition: .useCredential, credential: URLCredential(trust: trust))
        }
        if self.localCertificateUrls.isEmpty == true {
            return (disposition: .performDefaultHandling, credential: nil)
        }
        for localCertificateUrl in self.localCertificateUrls {
            let authentication = self._authentication(localCertificateUrl: localCertificateUrl, trust: trust)
            if authentication.disposition != .cancelAuthenticationChallenge {
                return authentication
            }
        }
        return (disposition: .cancelAuthenticationChallenge, credential: nil)
    }
    
    func _authentication(localCertificateUrl: URL, trust: SecTrust) -> (disposition: URLSession.AuthChallengeDisposition, credential: URLCredential?) {
        guard let localCertificateData = try? Data(contentsOf: localCertificateUrl) else {
            return (disposition: .cancelAuthenticationChallenge, credential: nil)
        }
        guard let localCertificate = SecCertificateCreateWithData(nil, localCertificateData as CFData) else {
            return (disposition: .cancelAuthenticationChallenge, credential: nil)
        }
        var trustResult: SecTrustResultType = .otherError
        SecTrustSetAnchorCertificates(trust, [ localCertificate ] as CFArray)
        SecTrustEvaluate(trust, &trustResult)
        if trustResult == SecTrustResultType.recoverableTrustFailure {
            SecTrustSetExceptions(trust, SecTrustCopyExceptions(trust))
            SecTrustEvaluate(trust, &trustResult)
        }
        switch trustResult {
        case .unspecified, .proceed:
            let localCertificateData: Data = SecCertificateCopyData(localCertificate) as Data
            let serverCertificateData: Data?
            if let serverCertificate = SecTrustGetCertificateAtIndex(trust, 0) {
                serverCertificateData = SecCertificateCopyData(serverCertificate) as Data
            } else {
                serverCertificateData = nil
            }
            if serverCertificateData == localCertificateData {
                return (disposition: .useCredential, credential: URLCredential(trust: trust))
            }
        default:
            break
        }
        return (disposition: .cancelAuthenticationChallenge, credential: nil)
    }
    
}

extension Api.Provider : URLSessionDelegate {

    public func urlSession(
        _ session: URLSession,
        didBecomeInvalidWithError error: Error?
    ) {
        self._queue.sync {
            self._tasks.removeAll()
        }
    }

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void
    ) {
        let authentication = self._authentication(challenge: challenge)
        completionHandler(authentication.disposition, authentication.credential)
    }
    
}

extension Api.Provider : URLSessionTaskDelegate {

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Swift.Void
    ) {
        let redirectRequest: URLRequest?
        if let query = self._query(task: task) {
            redirectRequest = query.redirect(request: request)
        } else {
            redirectRequest = nil
        }
        completionHandler(redirectRequest)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void
    ) {
        let authentication = self._authentication(challenge: challenge)
        completionHandler(authentication.disposition, authentication.credential)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void
    ) {
        var inputStream: InputStream? = nil
        if let request = task.originalRequest {
            if let stream = request.httpBodyStream {
                inputStream = stream.copy() as? InputStream
            }
        }
        completionHandler(inputStream)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        if let query = self._query(task: task) {
            query.upload(bytes: totalBytesSent, totalBytes: totalBytesExpectedToSend)
        }
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        if let query = self._remove(task: task) {
            query.finish(error: error)
        }
    }
    
}

extension Api.Provider : URLSessionDataDelegate {

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void
    ) {
        if let query = self._query(task: dataTask) {
            query.receive(response: response)
        }
        completionHandler(.allow)
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask
    ) {
        if let query = self._move(fromTask: dataTask, toTask: downloadTask) {
            query.become(task: downloadTask)
        }
    }

    @available(OSX 10.11, *)
    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome streamTask: URLSessionStreamTask
    ) {
        if let query = self._move(fromTask: dataTask, toTask: streamTask) {
            query.become(task: streamTask)
        }
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        if let query = self._query(task: dataTask) {
            query.receive(data: data)
        }
    }
    
}

extension Api.Provider : URLSessionDownloadDelegate {

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        if let query = self._query(task: downloadTask) {
            if let response = downloadTask.response {
                query.receive(response: response)
            }
            query.download(url: location)
        }
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        if let query = self._query(task: downloadTask) {
            query.download(bytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
        }
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64
    ) {
        if let query = self._query(task: downloadTask) {
            query.resumeDownload(bytes: fileOffset, totalBytes: expectedTotalBytes)
        }
    }
    
}
