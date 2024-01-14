//
//  KindKit
//

import Foundation

public extension Operator {
    
    final class Run< Pipeline : IPipeline > : IOperator {
        
        public typealias Input = Pipeline.Input
        public typealias Output = Pipeline.Output
        
        private let _pipeline: Pipeline
        private var _subscription: ISubscription!
        private var _next: IPipe!
        
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
        
        public func subscribe(next: IPipe) {
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

public extension IBuilder {
    
    func run< Pipeline : IPipeline >(
        pipeline: Pipeline
    ) -> Chain< Head, Operator.Run< Pipeline > > where
        Tail.Output == Pipeline.Input
    {
        return self.append(.init(pipeline))
    }
    
}
