//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Run< Pipeline : IFlowPipeline > : IFlowOperator {
        
        public typealias Input = Pipeline.Input
        public typealias Output = Pipeline.Output
        
        private let _pipeline: Pipeline
        private var _subscription: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ pipeline: Pipeline
        ) {
            self._pipeline = pipeline
            self._subscription = pipeline.subscribe(
                onReceiveValue: { [weak self] in self?._next.send(value: $0) },
                onReceiveError: { [weak self] in self?._next.send(error: $0) },
                onCompleted: { [weak self] in self?._next.completed() }
            )
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._pipeline.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            self._pipeline.send(error: error)
        }
        
        public func completed() {
            self._pipeline.completed()
        }
        
        public func cancel() {
            self._pipeline.cancel()
            self._next.cancel()
        }
        
    }
    
}

extension IFlowOperator {
    
    func run< Pipeline : IFlowPipeline >(
        _ pipeline: Pipeline
    ) -> Flow.Operator.Run< Pipeline > {
        let next = Flow.Operator.Run< Pipeline >(pipeline)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func run< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Head.Builder< Flow.Operator.Run< Pipeline > > where
        Input == Pipeline.Input
    {
        return .init(head: .init(pipeline))
    }
    
}

public extension Flow.Head.Builder {
    
    func run< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Run< Pipeline > > where
        Head.Output == Pipeline.Input
    {
        return .init(head: self.head, tail: self.head.run(pipeline))
    }
}

public extension Flow.Chain.Builder {
    
    func run< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Run< Pipeline > > where
        Head.Output == Pipeline.Input
    {
        return .init(head: self.head, tail: self.tail.run(pipeline))
    }
    
}
