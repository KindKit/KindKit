//
//  KindKit
//

import Foundation

public extension FlowOperator {
    
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
                onReceiveValue: { [unowned self] in self._next.send(value: $0) },
                onReceiveError: { [unowned self] in self._next.send(error: $0) },
                onCompleted: { [unowned self] in self._next.completed() }
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
        pipeline: Pipeline
    ) -> FlowOperator.Run< Pipeline > {
        let next = FlowOperator.Run< Pipeline >(pipeline)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func run< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> FlowBuilder.Head< FlowOperator.Run< Pipeline > > where
        Input == Pipeline.Input
    {
        return .init(head: .init(pipeline))
    }
    
}

public extension FlowBuilder.Head {
    
    func run< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> FlowBuilder.Chain< Head, FlowOperator.Run< Pipeline > > where
        Head.Output == Pipeline.Input
    {
        return .init(head: self.head, tail: self.head.run(pipeline: pipeline))
    }
}

public extension FlowBuilder.Chain {
    
    func run< Pipeline : IFlowPipeline >(
        pipeline: Pipeline
    ) -> FlowBuilder.Chain< Head, FlowOperator.Run< Pipeline > > where
        Head.Output == Pipeline.Input
    {
        return .init(head: self.head, tail: self.tail.run(pipeline: pipeline))
    }
    
}
