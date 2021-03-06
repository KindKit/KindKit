//
//  KindKitApi
//

import Foundation
import KindKitCore

public final class ApiTaskQuery< Request : IApiRequest, Response : IApiResponse > : IApiTaskQuery {

    public typealias ProgressClosure = (_ progress: Progress) -> Void
    public typealias CompleteClosure = (_ response: Response) -> Void

    public private(set) var task: URLSessionTask?
    public private(set) var provider: IApiProvider
    public private(set) var createAt: Date

    public private(set) var request: Request
    public private(set) var response: Response
    public private(set) var queue: DispatchQueue
    public private(set) var downloadProgress: Progress = Progress()
    public private(set) var onDownload: ProgressClosure?
    public private(set) var uploadProgress: Progress = Progress()
    public private(set) var onUpload: ProgressClosure?
    public private(set) var onCompleted: CompleteClosure

    var receivedResponse: URLResponse?
    var receivedData: Data?
    var canceled: Bool = false

    public init(
        provider: IApiProvider,
        request: Request,
        response: Response,
        queue: DispatchQueue,
        onCompleted: @escaping CompleteClosure
    ) {
        self.provider = provider
        self.createAt = Date()
        self.request = request
        self.response = response
        self.queue = queue
        self.onCompleted = onCompleted
    }

    public init(
        provider: IApiProvider,
        request: Request,
        response: Response,
        queue: DispatchQueue,
        onDownload: @escaping ProgressClosure,
        onCompleted: @escaping CompleteClosure
    ) {
        self.provider = provider
        self.createAt = Date()
        self.request = request
        self.response = response
        self.queue = queue
        self.onDownload = onDownload
        self.onCompleted = onCompleted
    }

    public init(
        provider: IApiProvider,
        request: Request,
        response: Response,
        queue: DispatchQueue,
        onUpload: @escaping ProgressClosure,
        onCompleted: @escaping CompleteClosure
    ) {
        self.provider = provider
        self.createAt = Date()
        self.request = request
        self.response = response
        self.queue = queue
        self.onUpload = onUpload
        self.onCompleted = onCompleted
    }
    
    deinit {
        self.cancel()
    }

    public func prepare(session: URLSession) -> Bool {
        if self.task == nil {
            if let urlRequest = self.request.urlRequest(provider: self.provider) {
                if self.onDownload != nil {
                    self.task = session.downloadTask(with: urlRequest)
                } else if self.onUpload != nil {
                    self.task = session.uploadTask(withStreamedRequest: urlRequest)
                } else {
                    self.task = session.dataTask(with: urlRequest)
                }
            }
        }
        return self.task != nil
    }

    public func start() {
        if let task = self.task {
            task.resume()
        }
    }
    
    public func redirect(request: URLRequest) -> URLRequest? {
        guard let original = self.task?.originalRequest else { return nil }
        guard self.request.redirect.contains(.enabled) == true else { return nil }
        var copy = request
        if self.request.redirect.contains(.authorization) == true {
            if let authorization = original.value(forHTTPHeaderField: "Authorization") {
                copy.addValue(authorization, forHTTPHeaderField: "Authorization")
            }
        }
        if self.request.redirect.contains(.method) == true {
            copy.httpMethod = original.httpMethod
        }
        return copy
    }

    public func cancel() {
        if let task = self.task {
            task.cancel()
            self.task = nil
            self.receivedResponse = nil
            self.receivedData = nil
            self.canceled = true
        }
    }

    public func upload(bytes: Int64, totalBytes: Int64) {
        self.uploadProgress.totalUnitCount = totalBytes
        self.uploadProgress.completedUnitCount = bytes
        if let upload = self.onUpload {
            self.queue.async {
                upload(self.uploadProgress)
            }
        }
    }

    public func resumeDownload(bytes: Int64, totalBytes: Int64) {
        self.downloadProgress.totalUnitCount = totalBytes
        self.downloadProgress.completedUnitCount = bytes
        if let download = self.onDownload {
            self.queue.async {
                download(self.downloadProgress)
            }
        }
    }

    public func download(bytes: Int64, totalBytes: Int64) {
        self.downloadProgress.totalUnitCount = totalBytes
        self.downloadProgress.completedUnitCount = bytes
        if let download = self.onDownload {
            self.queue.async {
                download(self.downloadProgress)
            }
        }
    }

    public func receive(response: URLResponse) {
        self.receivedResponse = response
    }

    public func become(task: URLSessionTask) {
        self.task = task
    }

    public func receive(data: Data) {
        if self.receivedData != nil {
            self.receivedData!.append(data)
        } else {
            self.receivedData = data
        }
    }

    public func download(url: URL) {
        if let data = try? Data(contentsOf: url) {
            self.receivedData = data
        }
    }

    public func finish(error: Error?) {
        self.task = nil
        if let error = error as NSError? {
            if self.canceled == false {
                self._parse(error: error)
            }
        } else {
            self._parse()
        }
    }
    
}

private extension ApiTaskQuery {

    func _parse() {
        guard let response = self.receivedResponse else { return }
        self.response.parse(response: response, data: self.receivedData)
        self._completeIfNeeded()
    }

    func _parse(error: Error) {
        self.response.parse(error: error)
        self._completeIfNeeded()
    }

    func _completeIfNeeded() {
        if self.response.error == nil {
            self._complete()
        } else {
            if(abs(self.createAt.timeIntervalSinceNow) <= self.request.retries) {
                self.response.reset()
                self.queue.asyncAfter(deadline: .now() + self.request.delay, execute: {
                    self.provider.send(query: self)
                })
            } else {
                self._complete()
            }
        }
    }

    func _complete() {
        #if DEBUG
        if self._logging(self.request.logging) == false {
            self._logging(self.provider.logging)
        }
        #endif
        self.queue.async(execute: {
            self.onCompleted(self.response)
        })
    }
    
    #if DEBUG
    
    @discardableResult
    func _logging(_ logging: ApiLogging) -> Bool {
        switch logging {
        case .never:
            return false
        case .whenError:
            if self.response.error != nil {
                print(self.debugString())
                return true
            }
            return false
        case .always:
            print(self.debugString())
            return true
        }
    }
    
    #endif

}

#if DEBUG

extension ApiTaskQuery : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<\(String(describing: self))\n")

        if let provider = self.provider as? IDebug {
            let debug = provider.debugString(0, nextIndent, indent)
            DebugString("Provider: \(debug)\n", &buffer, indent, nextIndent, indent)
        } else {
            DebugString("Provider: \(self.provider)\n", &buffer, indent, nextIndent, indent)
        }
        if let request = self.request as? IDebug {
            let debug = request.debugString(0, nextIndent, indent)
            DebugString("Request: \(debug)\n", &buffer, indent, nextIndent, indent)
        } else {
            DebugString("Request: \(self.request)\n", &buffer, indent, nextIndent, indent)
        }
        DebugString("CreateAt: \(self.createAt)\n", &buffer, indent, nextIndent, indent)
        DebugString("Duration: \(-self.createAt.timeIntervalSinceNow) s\n", &buffer, indent, nextIndent, indent)
        if let response = self.response as? IDebug {
            let debug = response.debugString(0, nextIndent, indent)
            DebugString("Response: \(debug)\n", &buffer, indent, nextIndent, indent)
        } else {
            DebugString("Response: \(self.response)\n", &buffer, indent, nextIndent, indent)
        }
        if let data = self.receivedData {
            var debug = String()
            if let string = String(data: data, encoding: .utf8) {
                string.debugString(&debug, 0, nextIndent, indent)
            } else {
                data.debugString(&debug, 0, nextIndent, indent)
            }
            DebugString("Received: \(debug)\n", &buffer, indent, nextIndent, indent)
        }

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
