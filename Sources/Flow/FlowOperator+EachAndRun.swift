//
//  KindKit
//

import Foundation

public extension FlowOperator {
    
    final class EachAndRun<
        Input : IFlowResult,
        Pipeline : IFlowPipeline
    > : IFlowOperator where
        Input.Success : Collection,
        Input.Success.Element == Pipeline.Input.Success,
        Input.Failure == Pipeline.Input.Failure
    {
        
        public typealias Input = Input
        public typealias Output = Result< [Pipeline.Output.Success], Pipeline.Output.Failure >
        
        private var _queue: [Input.Success.Element]
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
            self._queue.append(contentsOf: value)
        }
        
        public func receive(error: Input.Failure) {
            self._next.send(error: error)
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

private extension FlowOperator.EachAndRun {
    
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
            let value = self._queue.removeFirst()
            self._pipeline.send(value: value)
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
    
    func each< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> FlowOperator.EachAndRun< Output, Pipeline > where
        Output.Success : Collection,
        Output.Success.Element == Pipeline.Input.Success,
        Output.Failure == Pipeline.Input.Failure
    {
        let next = FlowOperator.EachAndRun< Output, Pipeline >(pipeline)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func each< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> FlowBuilder.Head< FlowOperator.EachAndRun< Input, Pipeline > > where
        Input.Success : Collection,
        Input.Success.Element == Pipeline.Input.Success,
        Input.Failure == Pipeline.Input.Failure
    {
        return .init(head: .init(pipeline))
    }
    
}

public extension FlowBuilder.Head {
    
    func each< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> FlowBuilder.Chain< Head, FlowOperator.EachAndRun< Head.Output, Pipeline > > where
        Head.Output.Success : Sequence,
        Head.Output.Success.Element == Pipeline.Input.Success,
        Head.Output.Failure == Pipeline.Input.Failure
    {
        return .init(head: self.head, tail: self.head.each(
            pipeline: pipeline
        ))
    }
}

public extension FlowBuilder.Chain {
    
    func each< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> FlowBuilder.Chain< Head, FlowOperator.EachAndRun< Tail.Output, Pipeline > > where
        Tail.Output.Success : Sequence,
        Tail.Output.Success.Element == Pipeline.Input.Success,
        Tail.Output.Failure == Pipeline.Input.Failure
    {
        return .init(head: self.head, tail: self.tail.each(
            pipeline: pipeline
        ))
    }
    
}
