//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Until< Input : IFlowResult, Pipeline : IFlowPipeline > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< [Pipeline.Output.Success], Pipeline.Output.Failure >
        
        private let _pipeline: Pipeline
        private let _resolve: (Result< Input.Success, Input.Failure >, Pipeline.Output.Success?) -> Resolve
        private var _input: Result< Input.Success, Input.Failure >?
        private var _store: [Pipeline.Output.Success] = []
        private var _subscription: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ pipeline: Pipeline,
            _ resolve: @escaping (Result< Input.Success, Input.Failure >, Pipeline.Output.Success?) -> Resolve
        ) {
            self._pipeline = pipeline
            self._resolve = resolve
            self._subscription = pipeline.subscribe(
                onReceiveValue: { [weak self] in self?._pipelineReceive($0) },
                onReceiveError: { [weak self] in self?._pipelineReceive($0) }
            )
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._input = .success(value)
            self._perform()
        }
        
        public func receive(error: Input.Failure) {
            self._input = .failure(error)
            self._perform()
        }
        
        public func completed() {
        }
        
        public func cancel() {
            self._cleanup()
            self._pipeline.cancel()
            self._next.cancel()
        }
        
    }
    
}

public extension Flow.Operator.Until {
    
    enum Resolve {
        
        case perform(Pipeline.Input.Success)
        case done
        
    }
    
}

private extension Flow.Operator.Until {
    
    func _perform() {
        guard let input = self._input else {
            self._cleanup()
            return
        }
        switch self._resolve(input, self._store.last) {
        case .perform(let result):
            self._pipeline.send(value: result)
            self._pipeline.completed()
        case .done:
            let value = self._store
            self._cleanup()
            self._next.send(value: value)
            self._next.completed()
        }
    }
    
    func _pipelineReceive(_ value: Pipeline.Output.Success) {
        self._store.append(value)
        self._perform()
    }
    
    func _pipelineReceive(_ error: Pipeline.Output.Failure) {
        self._cleanup()
        self._next.send(error: error)
        self._next.completed()
    }
    
    func _cleanup() {
        self._input = nil
        self._store.removeAll(keepingCapacity: true)
    }
    
}

public extension IFlowBuilder {
    
    func run< Pipeline : IFlowPipeline >(
        pipeline: Pipeline,
        until: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >, Pipeline.Output.Success?) -> Flow.Operator.Until< Tail.Output, Pipeline >.Resolve
    ) -> Flow.Chain< Head, Flow.Operator.Until< Tail.Output, Pipeline > > {
        return self.append(.init(pipeline, until))
    }
    
}
