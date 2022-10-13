//
//  KindKit
//

import Foundation

extension Api.Query {

    final class Task< Response : IApiResponse > : IApiTaskQuery {

        typealias ProgressClosure = (_ progress: Progress) -> Void
        typealias CompleteClosure = (_ response: Response.Result) -> Void

        var task: URLSessionTask
        let provider: IApiProvider
        let createAt: Date

        let request: Api.Request
        let response: Response
        let queue: DispatchQueue
        let downloadProgress: Progress
        let onDownload: ProgressClosure?
        let uploadProgress: Progress
        let onUpload: ProgressClosure?
        let onCompleted: CompleteClosure

        private var _receivedMeta: Api.Response.Meta?
        private var _receivedData: Data?
        private var _canceled: Bool
        
        init(
            provider: IApiProvider,
            session: URLSession,
            request: Api.Request,
            response: Response,
            queue: DispatchQueue,
            onDownload: ProgressClosure? = nil,
            onUpload: ProgressClosure? = nil,
            onCompleted: @escaping CompleteClosure
        ) throws {
            self.provider = provider
            self.createAt = Date()
            self.request = request
            self.response = response
            self.queue = queue
            self.downloadProgress = Progress()
            self.onDownload = onDownload
            self.uploadProgress = Progress()
            self.onUpload = onUpload
            self.onCompleted = onCompleted
            self._canceled = false
            
            let urlRequest = try self.request.urlRequest(provider: self.provider)
            if self.onDownload != nil {
                self.task = session.downloadTask(with: urlRequest)
            } else if self.onUpload != nil {
                self.task = session.uploadTask(withStreamedRequest: urlRequest)
            } else {
                self.task = session.dataTask(with: urlRequest)
            }
            self.task.resume()
        }
        
        deinit {
            self.cancel()
        }
        
        func redirect(request: URLRequest) -> URLRequest? {
            guard self._canceled == false else { return nil }
            guard let original = self.task.originalRequest else { return nil }
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

        func cancel() {
            if self._canceled == false {
                self.task.cancel()
                self._receivedMeta = nil
                self._receivedData = nil
                self._canceled = true
            }
        }

        func upload(bytes: Int64, totalBytes: Int64) {
            guard self._canceled == false else { return }
            self.uploadProgress.totalUnitCount = totalBytes
            self.uploadProgress.completedUnitCount = bytes
            if let upload = self.onUpload {
                self.queue.async {
                    upload(self.uploadProgress)
                }
            }
        }

        func resumeDownload(bytes: Int64, totalBytes: Int64) {
            guard self._canceled == false else { return }
            self.downloadProgress.totalUnitCount = totalBytes
            self.downloadProgress.completedUnitCount = bytes
            if let download = self.onDownload {
                self.queue.async {
                    download(self.downloadProgress)
                }
            }
        }

        func download(bytes: Int64, totalBytes: Int64) {
            guard self._canceled == false else { return }
            self.downloadProgress.totalUnitCount = totalBytes
            self.downloadProgress.completedUnitCount = bytes
            if let download = self.onDownload {
                self.queue.async {
                    download(self.downloadProgress)
                }
            }
        }

        func receive(response: URLResponse) {
            guard self._canceled == false else { return }
            self._receivedMeta = Api.Response.Meta(response)
        }

        func become(task: URLSessionTask) {
            guard self._canceled == false else { return }
            self.task = task
        }

        func receive(data: Data) {
            guard self._canceled == false else { return }
            if self._receivedData != nil {
                self._receivedData!.append(data)
            } else {
                self._receivedData = data
            }
        }

        func download(url: URL) {
            guard self._canceled == false else { return }
            if let data = try? Data(contentsOf: url) {
                self._receivedData = data
            }
        }

        func finish(error: Error?) {
            guard self._canceled == false else { return }
            if let error = error as NSError? {
                self._parse(error: error)
            } else {
                self._parse()
            }
        }
        
    }
    
}

private extension Api.Query.Task {

    func _parse() {
        let result: Response.Result
        if let meta = self._receivedMeta {
            result = self.response.parse(meta: meta, data: self._receivedData)
        } else {
            result = self.response.parse(meta: .init(), data: self._receivedData)
        }
        self._complete(result)
    }

    func _parse(error: Error) {
        let result = self.response.parse(error: error)
        self._complete(result)
    }

    func _complete(_ result: Response.Result) {
        #if DEBUG
        switch self.provider.logging {
        case .never:
            break
        case .whenError:
            switch result {
            case .failure:
                print(self.debugString())
            default:
                break
            }
        case .always:
            print(self.debugString())
        }
        #endif
        self.queue.async(execute: {
            self.onCompleted(result)
        })
    }

}

#if DEBUG

extension Api.Query.Task : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.debugString()
    }
    
}

extension Api.Query.Task : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<Api.Query.Task\n")

        DebugString("CreateAt: \(self.createAt)\n", &buffer, indent, nextIndent, indent)
        DebugString("Duration: \(-self.createAt.timeIntervalSinceNow) s\n", &buffer, indent, nextIndent, indent)
        if let request = self.task.originalRequest {
            let debug = request.debugString(0, nextIndent, indent)
            DebugString("OriginalRequest: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.task.originalRequest != self.task.currentRequest {
            if let request = task.currentRequest {
                let debug = request.debugString(0, nextIndent, indent)
                DebugString("CurrentRequest: \(debug)\n", &buffer, indent, nextIndent, indent)
            }
        }
        if let response = self.task.response {
            let debug = response.debugString(0, nextIndent, indent)
            DebugString("Response: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let error = self.task.error as? NSError {
            let debug = error.debugString(0, nextIndent, indent)
            DebugString("Error: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let data = self._receivedData {
            var debug = String()
            if let json = try? JSONSerialization.jsonObject(with: data) {
                if let array = json as? NSArray {
                    array.debugString(&debug, 0, nextIndent, indent)
                } else if let dictionay = json as? NSDictionary {
                    dictionay.debugString(&debug, 0, nextIndent, indent)
                }
            } else if let string = String(data: data, encoding: .utf8) {
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
