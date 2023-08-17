//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Stack<
        Input : IFlowResult,
        Pipeline : IFlowPipeline
    > : IFlowOperator where
        Input.Success == Pipeline.Input.Success,
        Input.Failure == Pipeline.Input.Failure
    {
        
        public typealias Input = Input
        public typealias Output = Result< [Pipeline.Output.Success], Pipeline.Output.Failure >
        
        private let _mode: Mode
        private var _queue: [Result< Input.Success, Input.Failure >] = []
        private var _value: [Pipeline.Output.Success] = []
        private var _error: Pipeline.Output.Failure?
        private let _pipeline: Pipeline
        private var _subscription: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ mode: Mode,
            _ pipeline: Pipeline
        ) {
            self._mode = mode
            self._pipeline = pipeline
            self._subscription = pipeline.subscribe(
                onReceiveValue: { [weak self] in self?._receive(value: $0) },
                onReceiveError: { [weak self] in self?._receive(error: $0) },
                onCompleted: { [weak self] in self?._completed() }
            )
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._queue.append(.success(value))
        }
        
        public func receive(error: Input.Failure) {
            self._queue.append(.failure(error))
        }
        
        public func completed() {
            self._completed()
        }
        
        public func cancel() {
            self._pipeline.cancel()
            self._next.cancel()
        }
        
    }
    
}

public extension Flow.Operator.Stack {
    
    enum Mode {
        
        case fifo
        case lifo
        
    }
    
}

private extension Flow.Operator.Stack {
    
    func _receive(value: Pipeline.Output.Success) {
        self._value.append(value)
    }
    
    func _receive(error: Pipeline.Output.Failure) {
        self._queue.removeAll()
        self._value.removeAll()
        self._error = error
    }
    
    func _completed() {
        if self._queue.isEmpty == false {
            switch self._item() {
            case .success(let value):
                self._pipeline.send(value: value)
            case .failure(let error):
                self._pipeline.send(error: error)
            }
            self._pipeline.completed()
        } else if let error = self._error {
            self._next.send(error: error)
            self._next.completed()
        } else {
            self._next.send(value: self._value)
            self._next.completed()
        }
    }
    
    func _item() -> Result< Input.Success, Input.Failure > {
        switch self._mode {
        case .fifo: return self._queue.removeFirst()
        case .lifo: return self._queue.removeLast()
        }
    }
    
}

public extension IFlowBuilder {
    
    func fifo< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Chain< Head, Flow.Operator.Stack< Tail.Output, Pipeline > > where
        Tail.Output.Success == Pipeline.Input.Success,
        Tail.Output.Failure == Never
    {
        return self.append(.init(.fifo, pipeline))
    }
    
    func fifo< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Chain< Head, Flow.Operator.Stack< Tail.Output, Pipeline > > where
        Tail.Output.Success == Pipeline.Input.Success,
        Tail.Output.Failure == Pipeline.Input.Failure
    {
        return self.append(.init(.fifo, pipeline))
    }
    
    func lifo< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Chain< Head, Flow.Operator.Stack< Tail.Output, Pipeline > > where
        Tail.Output.Success == Pipeline.Input.Success,
        Tail.Output.Failure == Never
    {
        return self.append(.init(.lifo, pipeline))
    }
    
    func lifo< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Chain< Head, Flow.Operator.Stack< Tail.Output, Pipeline > > where
        Tail.Output.Success == Pipeline.Input.Success,
        Tail.Output.Failure == Pipeline.Input.Failure
    {
        return self.append(.init(.lifo, pipeline))
    }
    
}
