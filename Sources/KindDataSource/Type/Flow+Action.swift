//
//  KindKit
//

import KindFlow
import KindNetwork

public extension Flow {
    
    final class Action<
        InputType : IResult,
        SuccessType,
        FailureType : Swift.Error,
        DataSourceType : IAction
    > : IOperator where
        InputType.Success == DataSourceType.Params
    {
        
        public typealias Input = InputType
        public typealias Output = Result< SuccessType, FailureType >
        
        private let _dataSource: DataSourceType
        private let _map: (Input.Success, DataSourceType.Result) -> Result< SuccessType, FailureType >
        private var _listner: ICancellable?
        private var _next: IPipe!
        
        init(
            _ dataSource: DataSourceType,
            _ map: @escaping (InputType.Success, DataSourceType.Result) -> Result< SuccessType, FailureType >
        ) {
            self._dataSource = dataSource
            self._map = map
        }
        
        public func subscribe(next: IPipe) {
            self._next = next
        }
        
        public func receive(value: InputType.Success) {
            self._listner = self._dataSource.onFinish.add(self, { $0._finish(value, $1) }).autoCancel()
            self._dataSource.perform(params: value)
        }
        
        public func receive(error: InputType.Failure) {
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

private extension Flow.Action {
    
    func _finish(_ input: InputType.Success, _ result: DataSourceType.Result) {
        self._listner = nil
        switch self._map(input, result) {
        case .success(let value): self._next.send(value: value)
        case .failure(let error): self._next.send(error: error)
        }
        self._next.completed()
    }
    
}

public extension IBuilder {
    
    func perform<
        SuccessType,
        FailureType : Swift.Error,
        DataSourceType : IAction
    >(
        dataSource: DataSourceType,
        map: @escaping (Tail.Output.Success, DataSourceType.Result) -> Result< SuccessType, FailureType >
    ) -> Chain< Head, Flow.Action< Tail.Output, SuccessType, FailureType, DataSourceType > > {
        return self.append(.init(dataSource, map))
    }
    
    func perform<
        SuccessType,
        FailureType : Swift.Error,
        DataSourceType : IAction
    >(
        dataSource: DataSourceType,
        success: @escaping (Tail.Output.Success, DataSourceType.Success) -> SuccessType,
        failure: @escaping (Tail.Output.Success, DataSourceType.Failure) -> FailureType
    ) -> Chain< Head, Flow.Action< Tail.Output, SuccessType, FailureType, DataSourceType > > {
        return self.append(.init(dataSource, { input, result -> Result< SuccessType, FailureType > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func perform<
        SuccessType,
        DataSourceType : IAction
    >(
        dataSource: DataSourceType,
        success: @escaping (Tail.Output.Success, DataSourceType.Success) -> SuccessType
    ) -> Chain< Head, Flow.Action< Tail.Output, SuccessType, DataSourceType.Failure, DataSourceType > > {
        return self.append(.init(dataSource, { input, result -> Result< SuccessType, DataSourceType.Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func perform<
        SuccessType,
        DataSourceType : IAction
    >(
        dataSource: DataSourceType,
        success: @escaping (Tail.Output.Success, DataSourceType.Success) -> SuccessType
    ) -> Chain< Head, Flow.Action< Tail.Output, SuccessType, DataSourceType.Failure, DataSourceType > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(dataSource, { input, result -> Result< SuccessType, DataSourceType.Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func perform<
        FailureType : Swift.Error,
        DataSourceType : IAction
    >(
        dataSource: DataSourceType,
        failure: @escaping (Tail.Output.Success, DataSourceType.Failure) -> FailureType
    ) -> Chain< Head, Flow.Action< Tail.Output, DataSourceType.Success, FailureType, DataSourceType > > {
        return self.append(.init(dataSource, { input, result -> Result< DataSourceType.Success, FailureType > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func perform<
        DataSourceType : IAction
    >(
        dataSource: DataSourceType
    ) -> Chain< Head, Flow.Action< Tail.Output, DataSourceType.Success, DataSourceType.Failure, DataSourceType > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(dataSource, { input, result -> DataSourceType.Result in
            return result
        }))
    }
    
    func perform<
        DataSourceType : IAction
    >(
        dataSource: DataSourceType
    ) -> Chain< Head, Flow.Action< Tail.Output, DataSourceType.Success, DataSourceType.Failure, DataSourceType > > where
        Tail.Output.Failure == DataSourceType.Failure
    {
        return self.append(.init(dataSource, { input, result -> DataSourceType.Result in
            return result
        }))
    }
    
}
