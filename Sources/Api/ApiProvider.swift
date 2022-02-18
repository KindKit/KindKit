//
//  KindKitApi
//

import Foundation
import KindKitCore

public final class ApiProvider : NSObject, IApiProvider {

    public var url: URL?
    public var queryParams: [String: Any]
    public var headers: [String: String]
    public var bodyParams: [String: Any]?
    public var allowInvalidCertificates: Bool
    public var localCertificateUrls: [URL]
    #if DEBUG
    public var logging: ApiLogging = .never
    #endif

    public private(set) var session: URLSession!
    public private(set) var sessionConfiguration: URLSessionConfiguration
    public private(set) var sessionQueue: OperationQueue
    
    private var _queue: DispatchQueue
    private var _taskQueries: [Int: IApiTaskQuery]

    public init(
        url: URL? = nil,
        queryParams: [String: Any] = [:],
        headers: [String: String] = [:],
        bodyParams: [String: Any]? = nil,
        allowInvalidCertificates: Bool = false,
        localCertificateUrls: [URL] = [],
        sessionConfiguration: URLSessionConfiguration,
        sessionQueue: OperationQueue
    ) {
        self.url = url
        self.queryParams = queryParams
        self.headers = headers
        self.bodyParams = bodyParams
        self.allowInvalidCertificates = allowInvalidCertificates
        self.localCertificateUrls = localCertificateUrls
        self.sessionConfiguration = sessionConfiguration
        self.sessionQueue = sessionQueue
        self._queue = DispatchQueue(label: "ApiProvider")
        self._taskQueries = [:]
        super.init()
        self.session = URLSession(
            configuration: self.sessionConfiguration,
            delegate: self,
            delegateQueue: self.sessionQueue
        )
    }
    
    public func send(query: IApiQuery) {
        if let taskQuery = query as? IApiTaskQuery {
            if taskQuery.prepare(session: self.session) == true {
                self._set(query: taskQuery)
                taskQuery.start()
            }
        } else {
            query.start()
        }
    }
    
}

public extension ApiProvider {

    func set(queryParam: String, value: Any?) {
        self._queue.sync {
            if let safeValue = value {
                self.queryParams[queryParam] = safeValue
            } else {
                self.queryParams.removeValue(forKey: queryParam)
            }
        }
    }

    func get(queryParam: String) -> Any? {
        var result: Any? = nil
        self._queue.sync {
            result = self.queryParams[queryParam]
        }
        return result
    }

    func removeAllQueryParams() {
        self._queue.sync {
            self.queryParams.removeAll()
        }
    }

    func set(header: String, value: String?) {
        self._queue.sync {
            if let safeValue = value {
                self.headers[header] = safeValue
            } else {
                self.headers.removeValue(forKey: header)
            }
        }
    }

    func get(header: String) -> Any? {
        var result: Any? = nil
        self._queue.sync {
            result = self.headers[header]
        }
        return result
    }

    func removeAllHeaders() {
        self._queue.sync {
            self.headers.removeAll()
        }
    }

    func set(bodyParam: String, value: Any?) {
        self._queue.sync {
            if let safeValue = value {
                if self.bodyParams == nil {
                    self.bodyParams = [:]
                }
                self.bodyParams![bodyParam] = safeValue
            } else {
                if self.bodyParams != nil {
                    self.bodyParams!.removeValue(forKey: bodyParam)
                }
            }
        }
    }

    func get(bodyParam: String) -> Any? {
        var result: Any? = nil
        self._queue.sync {
            if self.bodyParams != nil {
                result = self.bodyParams![bodyParam]
            }
        }
        return result
    }

    func removeAllBodyParams() {
        self._queue.sync {
            self.bodyParams = nil
        }
    }
    
}

// MARK: Private

private extension ApiProvider {
    
    func _set(query: IApiTaskQuery) {
        self._queue.sync {
            self._taskQueries[query.task!.taskIdentifier] = query
        }
    }
    
    func _query(task: URLSessionTask) -> IApiTaskQuery? {
        var query: IApiTaskQuery? = nil
        self._queue.sync {
            query = self._taskQueries[task.taskIdentifier]
        }
        return query
    }
    
    func _remove(task: URLSessionTask) -> IApiTaskQuery? {
        var query: IApiTaskQuery? = nil
        self._queue.sync {
            let key = task.taskIdentifier
            query = self._taskQueries[key]
            self._taskQueries.removeValue(forKey: key)
        }
        return query
    }
    
    func _move(fromTask: URLSessionTask, toTask: URLSessionTask) -> IApiTaskQuery? {
        var query: IApiTaskQuery? = nil
        self._queue.sync {
            query = self._taskQueries[fromTask.taskIdentifier]
            self._taskQueries.removeValue(forKey: fromTask.taskIdentifier)
            if let query = query {
                self._taskQueries[toTask.taskIdentifier] = query
            }
        }
        return query
    }
    
    func _authentication(challenge: URLAuthenticationChallenge) -> (disposition: URLSession.AuthChallengeDisposition, credential: URLCredential?) {
        guard let trust = challenge.protectionSpace.serverTrust else {
            if self.allowInvalidCertificates == true {
                return (disposition: .useCredential, credential: nil)
            } else {
                return (disposition: .cancelAuthenticationChallenge, credential: nil)
            }
        }
        if self.allowInvalidCertificates == true {
            let credential = URLCredential(trust: trust)
            return (disposition: .useCredential, credential: credential)
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

extension ApiProvider : URLSessionDelegate {

    public func urlSession(
        _ session: URLSession,
        didBecomeInvalidWithError error: Error?
    ) {
        self._queue.sync {
            self._taskQueries.removeAll()
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

extension ApiProvider : URLSessionTaskDelegate {

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

extension ApiProvider : URLSessionDataDelegate {

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

extension ApiProvider : URLSessionDownloadDelegate {

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

#if DEBUG

extension ApiProvider : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        if let url = self.url {
            let debug = url.debugString(0, nextIndent, indent)
            DebugString("Url: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.queryParams.count > 0 {
            let debug = self.queryParams.debugString(0, nextIndent, indent)
            DebugString("QueryParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.headers.count > 0 {
            let debug = self.headers.debugString(0, nextIndent, indent)
            DebugString("Headers: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let bodyParams = self.bodyParams {
            let debug = bodyParams.debugString(0, nextIndent, indent)
            DebugString("BodyParams: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.allowInvalidCertificates == true {
            let debug = self.allowInvalidCertificates.debugString(0, nextIndent, indent)
            DebugString("AllowInvalidCertificates: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
