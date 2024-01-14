//
//  KindKit
//

import Foundation

extension Provider {
    
    final class SessionDelegate : NSObject {
        
        public var authenticationChallenge: AuthenticationChallenge
        public var localCertificateUrls: [URL]
        
        private let _lock = Lock()
        private var _tasks: [Int : ITaskQuery] = [:]
        
        init(
            authenticationChallenge: AuthenticationChallenge = [],
            localCertificateUrls: [URL] = []
        ) {
            self.authenticationChallenge = authenticationChallenge
            self.localCertificateUrls = localCertificateUrls
            super.init()
        }
        
        deinit {
            for (_, task) in self._tasks {
                task.cancel()
            }
        }
        
        func append(_ taskQuery: ITaskQuery) {
            self._lock.perform({
                self._tasks[taskQuery.task.taskIdentifier] = taskQuery
            })
        }
        
    }
    
}

private extension Provider.SessionDelegate {
    
    func _query(task: URLSessionTask) -> ITaskQuery? {
        return self._lock.perform({
            return self._tasks[task.taskIdentifier]
        })
    }
    
    func _remove(task: URLSessionTask) -> ITaskQuery? {
        return self._lock.perform({
            return self._tasks.removeValue(forKey: task.taskIdentifier)
        })
    }
    
    func _move(fromTask: URLSessionTask, toTask: URLSessionTask) -> ITaskQuery? {
        return self._lock.perform({
            let query = self._tasks[fromTask.taskIdentifier]
            self._tasks.removeValue(forKey: fromTask.taskIdentifier)
            if let query = query {
                self._tasks[toTask.taskIdentifier] = query
            }
            return query
        })
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
        var trustError: CFError? = nil
        SecTrustSetAnchorCertificates(trust, [localCertificate] as CFArray)
        if SecTrustEvaluateWithError(trust, &trustError) == false {
            return (disposition: .cancelAuthenticationChallenge, credential: nil)
        }
        _ = SecTrustGetTrustResult(trust, &trustResult)
        if trustResult == SecTrustResultType.recoverableTrustFailure {
            SecTrustSetExceptions(trust, SecTrustCopyExceptions(trust))
            if SecTrustEvaluateWithError(trust, &trustError) == false {
                return (disposition: .cancelAuthenticationChallenge, credential: nil)
            } else {
                _ = SecTrustGetTrustResult(trust, &trustResult)
            }
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

extension Provider.SessionDelegate : URLSessionDelegate {

    public func urlSession(
        _ session: URLSession,
        didBecomeInvalidWithError error: Swift.Error?
    ) {
        self._lock.perform({
            self._tasks.removeAll()
        })
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

extension Provider.SessionDelegate : URLSessionTaskDelegate {

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
        didCompleteWithError error: Swift.Error?
    ) {
        if let query = self._remove(task: task) {
            query.finish(error: error)
        }
    }
    
}

extension Provider.SessionDelegate : URLSessionDataDelegate {

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

extension Provider.SessionDelegate : URLSessionDownloadDelegate {

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
