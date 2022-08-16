//
//  KindKitApi
//

import Foundation

extension Api.Query {
    
    final class Fail< Response : IApiResponse > : IApiQuery {
        
        typealias CompleteClosure = (_ response: Response.Result) -> Void
        
        let provider: IApiProvider
        var createAt: Date
        
        let response: Response
        let queue: DispatchQueue
        let onCompleted: CompleteClosure
        
        private var _workQueue: DispatchQueue
        private var _workItem: DispatchWorkItem!
        
        init(
            provider: IApiProvider,
            response: Response,
            queue: DispatchQueue,
            onCompleted: @escaping CompleteClosure
        ) {
            self.provider = provider
            self.createAt = Date()
            self.response = response
            self.queue = queue
            self.onCompleted = onCompleted
            self._workQueue = DispatchQueue.global(qos: .userInitiated)
            self._workItem = DispatchWorkItem(block: { [unowned self] in
                self._perform()
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
        let result = self.response.parse(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown))
        self.queue.async(execute: {
            self.onCompleted(result)
        })
    }
    
}
