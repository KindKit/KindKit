//
//  KindKit
//

import Foundation

extension Api.Query {
    
    final class Fail< Response : IApiResponse > : IApiQuery {
        
        typealias CompleteClosure = (_ response: Response.Result) -> Void
        
        let provider: Api.Provider
        var createAt: Date
        
        let error: Api.Error.Request
        let response: Response
        let queue: DispatchQueue
        let onCompleted: CompleteClosure
        
        private var _workQueue: DispatchQueue
        private var _workItem: DispatchWorkItem!
        
        init(
            provider: Api.Provider,
            error: Api.Error.Request,
            response: Response,
            queue: DispatchQueue,
            onCompleted: @escaping CompleteClosure
        ) {
            self.provider = provider
            self.createAt = Date()
            self.error = error
            self.response = response
            self.queue = queue
            self.onCompleted = onCompleted
            self._workQueue = DispatchQueue.global(qos: .userInitiated)
            self._workItem = DispatchWorkItem(block: { [weak self] in
                self?._perform()
            })
            self._workQueue.sync(execute: self._workItem)
        }
        
        deinit {
            self.cancel()
        }
        
        func redirect(request: URLRequest) -> URLRequest? {
            return nil
        }
        
        func cancel() {
            self._workItem.cancel()
        }
        
    }
    
}

private extension Api.Query.Fail {
    
    func _perform() {
        let result = self.response.parse(error: self.error)
        switch self.response.logging(provider: self.provider, result: result) {
        case .never:
            break
        case .errorOnly(let category):
            switch result {
            case .failure:
                Log.shared.log(message: .debug(
                    level: .error,
                    category: category,
                    info: self
                ))
            default:
                break
            }
        case .always(let category):
            Log.shared.log(message: .debug(
                level: .error,
                category: category,
                info: self
            ))
        }
        self.queue.async(execute: {
            self.onCompleted(result)
        })
    }
    
}

extension Api.Query.Fail : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "Api.Query.Fail", sequence: { items in
            items.append(.pair(
                string: "CreateAt",
                string: self.createAt.kk_format(
                    date: .init()
                        .format("yyyy-MM-dd'T'HH:mm:ssZ")
                )
            ))
            items.append(.pair(
                string: "Duration",
                string: (-self.createAt.timeIntervalSinceNow).kk_format(
                    dateComponents: .init()
                        .unitsStyle(.abbreviated)
                        .allowedUnits([ .second, .nanosecond ])
                )
            ))
        })
    }
    
}

extension Api.Query.Fail : CustomStringConvertible {
}

extension Api.Query.Fail : CustomDebugStringConvertible {
}
