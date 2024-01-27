//
//  KindKit
//

import Foundation
import KindDebug
import KindLog

final class ResponseQuery< Response : KindNetwork.Response > : TaskQuery {
    
    typealias ProgressClosure = @Sendable (_ progress: Progress) -> Void
    typealias CompleteClosure = @Sendable (_ response: Response.Result) -> Void
    
    var task: URLSessionTask
    let provider: Provider
    let createAt: Date
    
    let request: Request
    let response: Response
    let queue: DispatchQueue
    let downloadProgress: Progress
    let onDownload: ProgressClosure?
    let uploadProgress: Progress
    let onUpload: ProgressClosure?
    let onCompleted: CompleteClosure
    
    private var _lock = Lock()
    private var _receivedMeta: KindNetwork.MetaResponse?
    private var _receivedData: Data?
    private var _canceled: Bool
    
    init(
        provider: Provider,
        session: URLSession,
        request: Request,
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
        return self._lock.perform({
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
        self._lock.perform({
            self._cancel()
        })
    }
    
    func upload(bytes: Int64, totalBytes: Int64) {
        self._lock.perform({
            guard self._canceled == false else { return }
            self.uploadProgress.totalUnitCount = totalBytes
            self.uploadProgress.completedUnitCount = bytes
            if let upload = self.onUpload {
                upload(self.uploadProgress)
            }
        })
    }
    
    func resumeDownload(bytes: Int64, totalBytes: Int64) {
        self._lock.perform({
            guard self._canceled == false else { return }
            self.downloadProgress.totalUnitCount = totalBytes
            self.downloadProgress.completedUnitCount = bytes
            if let download = self.onDownload {
                download(self.downloadProgress)
            }
        })
    }
    
    func download(bytes: Int64, totalBytes: Int64) {
        self._lock.perform({
            guard self._canceled == false else { return }
            self.downloadProgress.totalUnitCount = totalBytes
            self.downloadProgress.completedUnitCount = bytes
            if let download = self.onDownload {
                download(self.downloadProgress)
            }
        })
    }
    
    func receive(response: URLResponse) {
        self._lock.perform({
            guard self._canceled == false else { return }
            self._receivedMeta = .init(response)
        })
    }
    
    func become(task: URLSessionTask) {
        self._lock.perform({
            guard self._canceled == false else { return }
            self.task = task
        })
    }
    
    func receive(data: Data) {
        self._lock.perform({
            guard self._canceled == false else { return }
            if self._receivedData != nil {
                self._receivedData!.append(data)
            } else {
                self._receivedData = data
            }
        })
    }
    
    func download(url: URL) {
        self._lock.perform({
            guard self._canceled == false else { return }
            if let data = try? Data(contentsOf: url) {
                self._receivedData = data
            }
        })
    }
    
    func finish(error: Swift.Error?) {
        self._lock.perform({
            guard self._canceled == false else { return }
            if let error = error as NSError? {
                self._parse(error: error)
            } else {
                self._parse()
            }
        })
    }
    
}

extension ResponseQuery : @unchecked Sendable {
}

private extension ResponseQuery {
    
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

    func _parse(error: Swift.Error) {
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
                KindLog.log(debug: .init(
                    level: .error,
                    category: category,
                    info: self
                ))
            default:
                break
            }
        case .always(let category):
            KindLog.log(debug: .init(
                level: .error,
                category: category,
                info: self
            ))
        }
        if self._canceled == false {
            self.queue.async(execute: {
                self.onCompleted(result)
            })
        }
    }

}

extension ResponseQuery : DebugTrait {
    
    public func buildInfo() -> Info {
        return ObjectInfo(name: "TaskQuery", sequenceBuilder: {
            KeyValueInfo(
                key: StringInfo("CreateAt"),
                value: StringInfo({
                    FormatterComponent(
                        source: self.createAt,
                        formatter: DateFormatter()
                            .format("yyyy-MM-dd'T'HH:mm:ssZ")
                    )
                })
            )
            KeyValueInfo(
                key: StringInfo("Duration"),
                value: StringInfo({
                    FormatterComponent(
                        source: -self.createAt.timeIntervalSinceNow,
                        formatter: DateComponentsFormatter()
                            .unitsStyle(.abbreviated)
                            .allowedUnits([ .second, .nanosecond ])
                    )
                })
            )
            if let value = self.task.originalRequest {
                KeyValueInfo(
                    key: StringInfo("Request"),
                    value: value
                )
            }
            if let value = self.task.response {
                KeyValueInfo(
                    key: StringInfo("Response"),
                    value: value
                )
            }
            if let value = self.task.error as? DebugTrait {
                KeyValueInfo(
                    key: StringInfo("Error"),
                    value: value
                )
            }
            if let value = self._receivedData {
                if value.isEmpty == false {
                    KeyValueInfo(
                        key: StringInfo("Body"),
                        value: value
                    )
                }
            }
        })
    }
    
}

extension ResponseQuery : CustomStringConvertible {
}

extension ResponseQuery : CustomDebugStringConvertible {
}
