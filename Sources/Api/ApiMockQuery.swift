//
//  KindKitApi
//

import Foundation

public final class ApiMockQuery< Response : IApiResponse > : IApiQuery {
    
    public typealias PrepareClosure = () -> (http: HTTPURLResponse?, data: Data?, error: Error?)
    public typealias CompleteClosure = (_ response: Response) -> Void
    
    public private(set) var provider: IApiProvider
    public private(set) var createAt: Date
    
    public private(set) var response: Response
    public private(set) var queue: DispatchQueue
    public private(set) var onPrepare: PrepareClosure
    public private(set) var onCompleted: CompleteClosure
    
    private var _workQueue: DispatchQueue
    private var _workItem: DispatchWorkItem?
    
    public init(
        provider: IApiProvider,
        response: Response,
        queue: DispatchQueue,
        onPrepare: @escaping PrepareClosure,
        onCompleted: @escaping CompleteClosure
    ) {
        self.provider = provider
        self.createAt = Date()
        self.response = response
        self.queue = queue
        self.onPrepare = onPrepare
        self.onCompleted = onCompleted
        self._workQueue = DispatchQueue.global(qos: .userInitiated)
    }
    
    deinit {
        self.cancel()
    }
    
    public func start() {
        if self._workItem == nil {
            let item = DispatchWorkItem(block: { [weak self] in
                guard let self = self, let workItem = self._workItem else { return }
                self._perform(workItem)
            })
            self._workItem = item
            self._workQueue.sync(execute: item)
        }
    }
    
    public func redirect(request: URLRequest) -> URLRequest? {
        return nil
    }
    
    public func cancel() {
        self._workItem?.cancel()
        self._workItem = nil
    }
    
}

private extension ApiMockQuery {
    
    func _perform(_ workItem: DispatchWorkItem) {
        let response = self.onPrepare()
        if let http = response.http {
            self.response.parse(response: http, data: response.data)
        } else if let error = response.error {
            self.response.parse(error: error)
        } else {
            self.response.parse(error: ApiError.invalidResponse)
        }
        self.queue.async(execute: {
            self.onCompleted(self.response)
        })
    }
    
}
