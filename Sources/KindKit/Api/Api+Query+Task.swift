//
//  KindKit
//

import Foundation

extension Api.Query {

    final class Task< Response : IApiResponse > : IApiTaskQuery {

        typealias ProgressClosure = (_ progress: Progress) -> Void
        typealias CompleteClosure = (_ response: Response.Result) -> Void

        var task: URLSessionTask
        let provider: Api.Provider
        let createAt: Date

        let request: Api.Request
        let response: Response
        let queue: DispatchQueue
        let downloadProgress: Progress
        let onDownload: ProgressClosure?
        let uploadProgress: Progress
        let onUpload: ProgressClosure?
        let onCompleted: CompleteClosure
        
        private var _queue = DispatchQueue(label: "KindKit.Api.Query.Task")
        private var _receivedMeta: Api.Response.Meta?
        private var _receivedData: Data?
        private var _canceled: Bool
        
        init(
            provider: Api.Provider,
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
            self._cancel()
        }
        
        func redirect(request: URLRequest) -> URLRequest? {
            return self._queue.sync(execute: {
                guard self._canceled == false else { return nil }
                guard let original = self.task.originalRequest else { return nil }
                guard self.request.redirect.contains(.enabled) == true else { return nil }
                var copy = request
                if self.request.redirect.contains(.method) == true {
                    copy.httpMethod = original.httpMethod
                }
                if self.request.redirect.contains(.authorization) == true {
                    if let authorization = original.value(forHTTPHeaderField: "Authorization") {
                        copy.addValue(authorization, forHTTPHeaderField: "Authorization")
                    }
                }
                return copy
            })
        }

        func cancel() {
            self._queue.async(flags: .barrier, execute: {
                self._cancel()
            })
        }

        func upload(bytes: Int64, totalBytes: Int64) {
            self._queue.async(execute: {
                guard self._canceled == false else { return }
                self.uploadProgress.totalUnitCount = totalBytes
                self.uploadProgress.completedUnitCount = bytes
                if let upload = self.onUpload {
                    upload(self.uploadProgress)
                }
            })
        }

        func resumeDownload(bytes: Int64, totalBytes: Int64) {
            self._queue.async(execute: {
                guard self._canceled == false else { return }
                self.downloadProgress.totalUnitCount = totalBytes
                self.downloadProgress.completedUnitCount = bytes
                if let download = self.onDownload {
                    download(self.downloadProgress)
                }
            })
        }

        func download(bytes: Int64, totalBytes: Int64) {
            self._queue.async(execute: {
                guard self._canceled == false else { return }
                self.downloadProgress.totalUnitCount = totalBytes
                self.downloadProgress.completedUnitCount = bytes
                if let download = self.onDownload {
                    download(self.downloadProgress)
                }
            })
        }

        func receive(response: URLResponse) {
            self._queue.async(execute: {
                guard self._canceled == false else { return }
                self._receivedMeta = Api.Response.Meta(response)
            })
        }

        func become(task: URLSessionTask) {
            self._queue.async(execute: {
                guard self._canceled == false else { return }
                self.task = task
            })
        }

        func receive(data: Data) {
            self._queue.async(execute: {
                guard self._canceled == false else { return }
                if self._receivedData != nil {
                    self._receivedData!.append(data)
                } else {
                    self._receivedData = data
                }
            })
        }

        func download(url: URL) {
            self._queue.async(execute: {
                guard self._canceled == false else { return }
                if let data = try? Data(contentsOf: url) {
                    self._receivedData = data
                }
            })
        }

        func finish(error: Error?) {
            self._queue.async(execute: {
                guard self._canceled == false else { return }
                if let error = error as NSError? {
                    self._parse(error: error)
                } else {
                    self._parse()
                }
            })
        }
        
    }
    
}

private extension Api.Query.Task {
    
    func _cancel() {
        if self._canceled == false {
            self.task.cancel()
            self._receivedMeta = nil
            self._receivedData = nil
            self._canceled = true
        }
    }

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
        switch self.response.logging(provider: self.provider, result: result)  {
        case .never:
            break
        case .errorOnly(let category):
            switch result {
            case .failure:
                Log.shared.log(level: .error, category: category, message: self.dump())
            default:
                break
            }
        case .always(let category):
            Log.shared.log(level: .error, category: category, message: self.dump())
        }
        if self._canceled == false {
            self.queue.async(execute: {
                self.onCompleted(result)
            })
        }
    }

}

extension Api.Query.Task : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.dump()
    }
    
}

extension Api.Query.Task : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(
            inter: indent,
            key: "CreateAt",
            value: self.createAt
        )
        buff.append(
            inter: indent,
            key: "Duration",
            value: -self.createAt.timeIntervalSinceNow,
            valueFormatter: .dateComponents()
                .unitsStyle(.abbreviated)
                .allowedUnits([ .second, .nanosecond ])
        )
        if let request = self.task.originalRequest {
            buff.append(inter: indent, key: "Request", value: request)
        }
        if let response = self.task.response {
            buff.append(inter: indent, key: "Response", value: response)
        }
        if let error = self.task.error as? IDebug {
            buff.append(inter: indent, key: "Error", value: error)
        }
        if let data = self._receivedData {
            if data.isEmpty == false {
                if let json = try? JSONSerialization.jsonObject(with: data) {
                    if let root = json as? NSArray {
                        buff.append(
                            inter: indent,
                            key: "Body",
                            value: root
                        )
                    } else if let root = json as? NSDictionary {
                        buff.append(
                            inter: indent,
                            key: "Body",
                            value: root
                        )
                    }
                } else if let string = String(data: data, encoding: .utf8) {
                    buff.append(
                        inter: indent,
                        key: "Body",
                        value: string.kk_escape([ .tab, .return, .newline ])
                    )
                } else {
                    buff.append(
                        inter: indent,
                        key: "Body",
                        value: data
                    )
                }
            }
        }
    }
    
}
