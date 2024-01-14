//
//  KindKit
//

import KindEvent
import KindNetwork

public extension Page {

    final class Api< ElementType, CursorType, ResponseType : KindNetwork.IResponse > : IPage {
        
        public typealias Success = [ElementType]
        public typealias Failure = ResponseType.Failure
        public typealias Result = Swift.Result< Success, Failure >
        
        public var isLoading: Bool {
            return self._task != nil
        }
        public private(set) var canMore: Bool
        public private(set) var result: Result?
        public let onFinish = Signal< Void, Result >()
        
        private let _provider: KindNetwork.Provider
        private let _request: (CursorType?) throws -> KindNetwork.Request
        private let _response: (CursorType?) -> ResponseType
        private let _elementsWithResponse: (ResponseType.Success) -> Success
        private let _cursorWithResponse: (CursorType?, ResponseType.Success) -> CursorType
        private let _canMoreWithResponse: (CursorType?, ResponseType.Success) -> Bool
        private var _cursor: CursorType?
        private var _task: ICancellable?
        
        public init(
            provider: KindNetwork.Provider,
            request: @escaping (CursorType?) throws -> KindNetwork.Request,
            response: @escaping (CursorType?) -> ResponseType,
            elementsWithResponse: @escaping (ResponseType.Success) -> Success,
            cursorWithResponse: @escaping (CursorType?, ResponseType.Success) -> CursorType,
            canMoreWithResponse: @escaping (CursorType?, ResponseType.Success) -> Bool
        ) {
            self.canMore = true
            self._provider = provider
            self._request = request
            self._response = response
            self._elementsWithResponse = elementsWithResponse
            self._cursorWithResponse = cursorWithResponse
            self._canMoreWithResponse = canMoreWithResponse
        }
        
        deinit {
            self.cancel()
        }

        public func load(reload: Bool) {
            guard self.isLoading == false else { return }
            let cursor: CursorType?
            if reload == true || self.result == nil {
                cursor = nil
            } else {
                cursor = self._cursor
            }
            self._task = self._provider.send(
                request: try self._request(cursor),
                response: self._response(cursor),
                queue: .main,
                completed: { [weak self] in self?._completed(cursor, $0) }
            )
        }
        
        public func cancel() {
            self._task?.cancel()
            self._task = nil
        }

    }
    
}

private extension Page.Api {

    func _completed(_ cursor: CursorType?, _ response: Swift.Result< ResponseType.Success, ResponseType.Failure >) {
        switch response {
        case .success(let responseSuccess):
            let responseElements = self._elementsWithResponse(responseSuccess)
            switch self.result {
            case .success(let resultElements):
                if cursor == nil {
                    self.result = .success(responseElements)
                } else {
                    self.result = .success(resultElements + responseElements)
                }
            case .failure, .none:
                self.result = .success(responseElements)
            }
            self._cursor = self._cursorWithResponse(cursor, responseSuccess)
            self.canMore = self._canMoreWithResponse(cursor, responseSuccess)
            self._task = nil
            self.onFinish.emit(.success(responseElements))
        case .failure(let responseError):
            self.result = .failure(responseError)
            self._task = nil
            self.onFinish.emit(.failure(responseError))
        }
    }
    
}
