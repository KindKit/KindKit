//
//  KindKit
//

import Foundation

public extension DataSource.Page {

    final class Api< Element, Cursor, Response : IApiResponse > : IPageDataSource {
        
        public typealias Success = [Element]
        public typealias Failure = Response.Failure
        public typealias Result = Swift.Result< Success, Failure >
        
        public var isLoading: Bool {
            return self._task != nil
        }
        public private(set) var canMore: Bool
        public private(set) var result: Result?
        public let onFinish = Signal.Args< Void, Result >()
        
        private let _provider: KindKit.Api.Provider
        private let _request: (Cursor?) throws -> KindKit.Api.Request
        private let _response: (Cursor?) -> Response
        private let _elementsWithResponse: (Response.Success) -> Success
        private let _cursorWithResponse: (Cursor?, Response.Success) -> Cursor
        private let _canMoreWithResponse: (Cursor?, Response.Success) -> Bool
        private var _cursor: Cursor?
        private var _task: ICancellable?
        
        public init(
            provider: KindKit.Api.Provider,
            request: @escaping (Cursor?) throws -> KindKit.Api.Request,
            response: @escaping (Cursor?) -> Response,
            elementsWithResponse: @escaping (Response.Success) -> Success,
            cursorWithResponse: @escaping (Cursor?, Response.Success) -> Cursor,
            canMoreWithResponse: @escaping (Cursor?, Response.Success) -> Bool
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
            let cursor: Cursor?
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

private extension DataSource.Page.Api {

    func _completed(_ cursor: Cursor?, _ response: Swift.Result< Response.Success, Response.Failure >) {
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
