//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Lifo<
        Input : IFlowResult,
        Pipeline : IFlowPipeline
    > : IFlowOperator where
        Input.Success == Pipeline.Input.Success,
        Input.Failure == Pipeline.Input.Failure
    {
        
        public typealias Input = Input
        public typealias Output = Result< [Pipeline.Output.Success], Pipeline.Output.Failure >
        
        private var _queue: [Result< Input.Success, Input.Failure >]
        private var _value: [Pipeline.Output.Success]
        private var _error: Pipeline.Output.Failure?
        private let _pipeline: Pipeline
        private var _subscription: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ pipeline: Pipeline
        ) {
            self._queue = []
            self._value = []
            self._error = nil
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

private extension Flow.Operator.Lifo {
    
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
            switch self._queue.removeLast() {
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
    
}

extension IFlowOperator {
    
    func lifo< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Operator.Lifo< Output, Pipeline > where
        Output.Success == Pipeline.Input.Success,
        Output.Failure == Pipeline.Input.Failure
    {
        let next = Flow.Operator.Lifo< Output, Pipeline >(pipeline)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func lifo< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Head.Builder< Flow.Operator.Lifo< Input, Pipeline > > where
        Input.Success == Pipeline.Input.Success,
        Input.Failure == Pipeline.Input.Failure
    {
        return .init(head: .init(pipeline))
    }
    
}

public extension Flow.Head.Builder {
    
    func lifo< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Lifo< Head.Output, Pipeline > > where
        Head.Output.Success == Pipeline.Input.Success,
        Head.Output.Failure == Pipeline.Input.Failure
    {
        return .init(head: self.head, tail: self.head.lifo(
            pipeline: pipeline
        ))
    }
}

public extension Flow.Chain.Builder {
    
    func lifo< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Lifo< Tail.Output, Pipeline > > where
        Tail.Output.Success == Pipeline.Input.Success,
        Tail.Output.Failure == Pipeline.Input.Failure
    {
        return .init(head: self.head, tail: self.tail.lifo(
            pipeline: pipeline
        ))
    }
    
}
