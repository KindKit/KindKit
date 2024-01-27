//
//  KindKit
//

import Foundation
import KindDebug
import KindLog

extension Query {
    
    final class Fail< Response : IResponse > : IQuery {
        
        typealias CompleteClosure = (_ response: Response.Result) -> Void
        
        let provider: Provider
        var createAt: Date
        
        let error: Error.Request
        let response: Response
        let queue: DispatchQueue
        let onCompleted: CompleteClosure
        
        private var _workQueue: DispatchQueue
        private var _workItem: DispatchWorkItem!
        
        init(
            provider: Provider,
            error: Error.Request,
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

private extension Query.Fail {
    
    func _perform() {
        let result = self.response.parse(error: self.error)
        switch self.response.logging(provider: self.provider, result: result) {
        case .never:
            break
        case .errorOnly(let category):
            switch result {
            case .failure:
                KindLog.default.log(debug: .init(
                    level: .error,
                    category: category,
                    info: self
                ))
            default:
                break
            }
        case .always(let category):
            KindLog.default.log(debug: .init(
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

extension Query.Fail : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        return .object(name: "Query.Fail", sequence: { items in
            items.append(.pair(
                string: "CreateAt",
                string: .kk_build({
                    FormatterComponent(
                        source: self.createAt,
                        formatter: DateFormatter()
                            .format("yyyy-MM-dd'T'HH:mm:ssZ")
                    )
                })
            ))
            items.append(.pair(
                string: "Duration",
                string: .kk_build({
                    FormatterComponent(
                        source: -self.createAt.timeIntervalSinceNow,
                        formatter: DateComponentsFormatter()
                            .unitsStyle(.abbreviated)
                            .allowedUnits([ .second, .nanosecond ])
                    )
                })
            ))
        })
    }
    
}

extension Query.Fail : CustomStringConvertible {
}

extension Query.Fail : CustomDebugStringConvertible {
}
