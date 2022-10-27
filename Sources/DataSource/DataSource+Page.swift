//
//  KindKit
//

import Foundation

public extension DataSource {

    final class Page< Provider : IApiProvider, Response : IApiResponse, Element, Cursor > : IPageDataSource, ICancellable {
        
        public typealias Success = [Element]
        public typealias Failure = Response.Failure
        public typealias Result = Swift.Result< Success, Failure >
        
        public private(set) var result: Result?
        public var isLoading: Bool {
            return self._task != nil
        }
        public private(set) var canMore: Bool
        
        private let _provider: Provider
        private let _request: (Cursor?) throws -> Api.Request?
        private let _response: (Cursor?) -> Response
        private let _elementsWithResponse: (Response.Success) -> Success
        private let _cursorWithResponse: (Cursor?, Response.Success) -> Cursor
        private let _canMoreWithResponse: (Cursor?, Response.Success) -> Bool
        private let _completed: (Result) -> Void
        private var _cursor: Cursor?
        private var _task: ICancellable?
        
        public init(
            provider: Provider,
            request: @escaping (Cursor?) throws -> Api.Request?,
            response: @escaping (Cursor?) -> Response,
            elementsWithResponse: @escaping (Response.Success) -> Success,
            cursorWithResponse: @escaping (Cursor?, Response.Success) -> Cursor,
            canMoreWithResponse: @escaping (Cursor?, Response.Success) -> Bool,
            completed: @escaping (Result) -> Void
        ) {
            self.canMore = true
            self._provider = provider
            self._request = request
            self._response = response
            self._elementsWithResponse = elementsWithResponse
            self._cursorWithResponse = cursorWithResponse
            self._canMoreWithResponse = canMoreWithResponse
            self._completed = completed
        }
        
        deinit {
            self._task?.cancel()
            self._task = nil
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

private extension DataSource.Page {

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
            self._completed(.success(responseElements))
        case .failure(let responseError):
            self.result = .failure(responseError)
            self._task = nil
            self._completed(.failure(responseError))
        }
    }
    
}
