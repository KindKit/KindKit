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
        private let _success: (Input.Success, DataSource.Success) -> Success
        private let _failure: (Input.Success, DataSource.Failure) -> Failure
        private var _listner: ICancellable?
        private var _next: IFlowPipe!
        
        init(
            _ dataSource: DataSource,
            _ success: @escaping (Input.Success, DataSource.Success) -> Success,
            _ failure: @escaping (Input.Success, DataSource.Failure) -> Failure
        ) {
            self._dataSource = dataSource
            self._success = success
            self._failure = failure
        }
        
        convenience init(
            _ dataSource: DataSource,
            _ success: @escaping (Input.Success, DataSource.Success) -> Success
        ) where
            Failure == DataSource.Failure
        {
            self.init(dataSource, success, { _, error in error })
        }
        
        convenience init(
            _ dataSource: DataSource,
            _ failure: @escaping (Input.Success, DataSource.Failure) -> Failure
        ) where
            Success == DataSource.Success
        {
            self.init(dataSource, { _, value in value }, failure)
        }
        
        convenience init(
            _ dataSource: DataSource
        ) where
            Success == DataSource.Success,
            Failure == DataSource.Failure
        {
            self.init(dataSource, { _, value in value }, { _, error in error })
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._listner = self._dataSource.onFinish.subscribe(self, { $0._finish(value, $1) })
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
    
    func _finish(_ input: Input.Success, _ result: DataSource.Result?) {
        self._listner = nil
        switch result {
        case .success(let value): self._next.send(value: self._success(input, value))
        case .failure(let error): self._next.send(error: self._failure(input, error))
        case .none:
            break
        }
        self._next.completed()
    }
    
}

extension IFlowOperator {
    
    func perform<
        Success,
        Failure : Swift.Error,
        DataSource : IActionDataSource
    >(
        _ dataSource: DataSource,
        _ success: @escaping (Output.Success, DataSource.Success) -> Success,
        _ failure: @escaping (Output.Success, DataSource.Failure) -> Failure
    ) -> KindKit.DataSource.Flow.Action< Output, Success, Failure, DataSource > where
        Output.Failure == Failure
    {
        let next = KindKit.DataSource.Flow.Action< Output, Success, Failure, DataSource >(dataSource, success, failure)
        self.subscribe(next: next)
        return next
    }
    
    func perform<
        Success,
        DataSource : IActionDataSource
    >(
        _ dataSource: DataSource,
        _ success: @escaping (Output.Success, DataSource.Success) -> Success
    ) -> KindKit.DataSource.Flow.Action< Output, Success, DataSource.Failure, DataSource > where
        Output.Failure == DataSource.Failure
    {
        let next = KindKit.DataSource.Flow.Action< Output, Success, DataSource.Failure, DataSource >(dataSource, success)
        self.subscribe(next: next)
        return next
    }
    
    func perform<
        Failure : Swift.Error,
        DataSource : IActionDataSource
    >(
        _ dataSource: DataSource,
        _ failure: @escaping (Output.Success, DataSource.Failure) -> Failure
    ) -> KindKit.DataSource.Flow.Action< Output, DataSource.Success, Failure, DataSource > where
        Output.Failure == Failure
    {
        let next = KindKit.DataSource.Flow.Action< Output, DataSource.Success, Failure, DataSource >(dataSource, failure)
        self.subscribe(next: next)
        return next
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        _ dataSource: DataSource
    ) -> KindKit.DataSource.Flow.Action< Output, DataSource.Success, DataSource.Failure, DataSource > where
        Output.Failure == DataSource.Failure
    {
        let next = KindKit.DataSource.Flow.Action< Output, DataSource.Success, DataSource.Failure, DataSource >(dataSource)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func perform<
        Success,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Input.Success, DataSource.Success) -> Success,
        failure: @escaping (Input.Success, DataSource.Failure) -> Input.Failure
    ) -> Flow.Head.Builder< KindKit.DataSource.Flow.Action< Input, Success, Input.Failure, DataSource > > {
        return .init(head: .init(dataSource, success, failure))
    }
    
    func perform<
        Success,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Input.Success, DataSource.Success) -> Success
    ) -> Flow.Head.Builder< KindKit.DataSource.Flow.Action< Input, Success, DataSource.Failure, DataSource > > where
        Input.Failure == DataSource.Failure
    {
        return .init(head: .init(dataSource, success))
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        failure: @escaping (Input.Success, DataSource.Failure) -> Input.Failure
    ) -> Flow.Head.Builder< KindKit.DataSource.Flow.Action< Input, DataSource.Success, Input.Failure, DataSource > > {
        return .init(head: .init(dataSource, failure))
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        dataSource: DataSource
    ) -> Flow.Head.Builder< KindKit.DataSource.Flow.Action< Input, DataSource.Success, DataSource.Failure, DataSource > > where
        Input.Failure == DataSource.Failure
    {
        return .init(head: .init(dataSource))
    }
    
}

public extension Flow.Head.Builder {
    
    func perform<
        Success,
        Failure : Swift.Error,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Head.Output.Success, DataSource.Success) -> Success,
        failure: @escaping (Head.Output.Success, DataSource.Failure) -> Failure
    ) -> Flow.Chain.Builder< Head, KindKit.DataSource.Flow.Action< Head.Output, Success, Failure, DataSource > > where
        Head.Output.Failure == Failure
    {
        return .init(head: self.head, tail: self.head.perform(dataSource, success, failure))
    }
    
    func perform<
        Success,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Head.Output.Success, DataSource.Success) -> Success
    ) -> Flow.Chain.Builder< Head, KindKit.DataSource.Flow.Action< Head.Output, Success, DataSource.Failure, DataSource > > where
        Head.Output.Failure == DataSource.Failure
    {
        return .init(head: self.head, tail: self.head.perform(dataSource, success))
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        failure: @escaping (Head.Output.Success, DataSource.Failure) -> Head.Output.Failure
    ) -> Flow.Chain.Builder< Head, KindKit.DataSource.Flow.Action< Head.Output, DataSource.Success, Head.Output.Failure, DataSource > > {
        return .init(head: self.head, tail: self.head.perform(dataSource, failure))
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        dataSource: DataSource
    ) -> Flow.Chain.Builder< Head, KindKit.DataSource.Flow.Action< Head.Output, DataSource.Success, DataSource.Failure, DataSource > > where
        Head.Output.Failure == DataSource.Failure
    {
        return .init(head: self.head, tail: self.head.perform(dataSource))
    }
    
}

public extension Flow.Chain.Builder {
    
    func perform<
        Success,
        Failure : Swift.Error,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Tail.Output.Success, DataSource.Success) -> Success,
        failure: @escaping (Tail.Output.Success, DataSource.Failure) -> Failure
    ) -> Flow.Chain.Builder< Head, KindKit.DataSource.Flow.Action< Tail.Output, Success, Failure, DataSource > > where
        Tail.Output.Failure == Failure
    {
        return .init(head: self.head, tail: self.tail.perform(dataSource, success, failure))
    }
    
    func perform<
        Success,
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        success: @escaping (Tail.Output.Success, DataSource.Success) -> Success
    ) -> Flow.Chain.Builder< Head, KindKit.DataSource.Flow.Action< Tail.Output, Success, DataSource.Failure, DataSource > > where
        Tail.Output.Failure == DataSource.Failure
    {
        return .init(head: self.head, tail: self.tail.perform(dataSource, success))
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        dataSource: DataSource,
        failure: @escaping (Tail.Output.Success, DataSource.Failure) -> Tail.Output.Failure
    ) -> Flow.Chain.Builder< Head, KindKit.DataSource.Flow.Action< Tail.Output, DataSource.Success, Tail.Output.Failure, DataSource > > {
        return .init(head: self.head, tail: self.tail.perform(dataSource, failure))
    }
    
    func perform<
        DataSource : IActionDataSource
    >(
        dataSource: DataSource
    ) -> Flow.Chain.Builder< Head, KindKit.DataSource.Flow.Action< Tail.Output, DataSource.Success, DataSource.Failure, DataSource > > where
        Tail.Output.Failure == DataSource.Failure
    {
        return .init(head: self.head, tail: self.tail.perform(dataSource))
    }
    
}
