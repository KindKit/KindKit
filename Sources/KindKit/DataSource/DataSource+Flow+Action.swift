//
//  KindKit
//

import Foundation

public extension DataSource.Flow {
    
    final class Action<
        Input : IFlowResult,
        Success,
        Failure : Swift.Error,
        DataSource : IActionDataSource
    > : IFlowOperator where
        Input.Success == DataSource.Params
    {
        
        public typealias Input = Input
        public typealias Output = Result< Success, Failure >
        
        private let _dataSource: DataSource
        private let _map: (Input.Success, DataSource.Result) -> Result< Success, Failure >
        private var _listner: ICancellable?
        private var _next: IFlowPipe!
        
        init(
            _ dataSource: DataSource,
            _ map: @escaping (Input.Success, DataSource.Result) -> Result< Success, Failure >
        ) {
            self._dataSource = dataSource
            self._map = map
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._listner = self._dataSource.onFinish.subscribe(self, { $0._finish(value, $1) }).autoCancel()
            self._dataSource.perform(params: value)
        }
        
        public func receive(error: Input.Failure) {
            self._dataSource.cancel()
            self._next.send(error: error)
            self._next.completed()
        }
        
        public func completed() {
        }
        
        public func cancel() {
            self._dataSource.cancel()
            self._next.cancel()
        }
        
    }
    
}

private extension DataSource.Flow.Action {
    
    func _finish(_ input: Input.Success, _ result: DataSource.Result) {
        self._listner = nil
        switch self._map(input, result) {
        case .success(let value): self._next.send(value: value)
        case .failure(let error): self._next.send(error: error)
        }
        self._next.completed()
    }
    
}

public extension IFlowBuilder {
    
    func perform<
        Success,
        Failure : Swift.Error,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        map: @escaping (Tail.Output.Success, DataSource.Result) -> Result< Success, Failure >
    ) -> Flow.Chain< Head, KindKit.DataSource.Flow.Action< Tail.Output, Success, Failure, DataSource > > {
        return self.append(.init(dataSource, map))
    }
    
    func perform<
        Success,
        Failure : Swift.Error,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Tail.Output.Success, DataSource.Success) -> Success,
        failure: @escaping (Tail.Output.Success, DataSource.Failure) -> Failure
    ) -> Flow.Chain< Head, KindKit.DataSource.Flow.Action< Tail.Output, Success, Failure, DataSource > > {
        return self.append(.init(dataSource, { input, result -> Result< Success, Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func perform<
        Success,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Tail.Output.Success, DataSource.Success) -> Success
    ) -> Flow.Chain< Head, KindKit.DataSource.Flow.Action< Tail.Output, Success, DataSource.Failure, DataSource > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(dataSource, { input, result -> Result< Success, DataSource.Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func perform<
        Success,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Tail.Output.Success, DataSource.Success) -> Success
    ) -> Flow.Chain< Head, KindKit.DataSource.Flow.Action< Tail.Output, Success, DataSource.Failure, DataSource > > where
        Tail.Output.Failure == DataSource.Failure
    {
        return self.append(.init(dataSource, { input, result -> Result< Success, DataSource.Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func perform<
        Failure : Swift.Error,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        failure: @escaping (Tail.Output.Success, DataSource.Failure) -> Failure
    ) -> Flow.Chain< Head, KindKit.DataSource.Flow.Action< Tail.Output, DataSource.Success, Failure, DataSource > > {
        return self.append(.init(dataSource, { input, result -> Result< DataSource.Success, Failure > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        dataSource: DataSource
    ) -> Flow.Chain< Head, KindKit.DataSource.Flow.Action< Tail.Output, DataSource.Success, DataSource.Failure, DataSource > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(dataSource, { input, result -> DataSource.Result in
            return result
        }))
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        dataSource: DataSource
    ) -> Flow.Chain< Head, KindKit.DataSource.Flow.Action< Tail.Output, DataSource.Success, DataSource.Failure, DataSource > > where
        Tail.Output.Failure == DataSource.Failure
    {
        return self.append(.init(dataSource, { input, result -> DataSource.Result in
            return result
        }))
    }
    
}
