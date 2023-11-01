//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Fork< Pipeline : IFlowPipeline > : IFlowOperator {
        
        public typealias Input = Pipeline.Input
        public typealias Output = Result< [Pipeline.Output.Success], Pipeline.Output.Failure >

        private let _pipelines: [Pipeline]
        private var _accumulator: [Result< Pipeline.Output.Success, Pipeline.Output.Failure >?]
        private var _subscriptions: [IFlowSubscription]!
        private var _next: IFlowPipe!
        
        init< Pipelines : Swift.Sequence >(
            _ pipelines: Pipelines
        ) where Pipelines.Element == Pipeline {
            self._pipelines = .init(pipelines)
            self._accumulator = .init(repeating: nil, count: self._pipelines.count)
            self._subscriptions = self._pipelines.map({ pipeline in
                pipeline.subscribe(
                    onReceiveValue: { [weak self] in self?._receive(pipeline: pipeline, value: $0) },
                    onReceiveError: { [weak self] in self?._receive(pipeline: pipeline, error: $0) },
                    onCompleted: { [weak self] in self?._completed() }
                )
            })
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            for pipeline in self._pipelines {
                pipeline.send(value: value)
            }
        }
        
        public func receive(error: Input.Failure) {
            for pipeline in self._pipelines {
                pipeline.send(error: error)
            }
        }
        
        public func completed() {
            for pipeline in self._pipelines {
                pipeline.completed()
            }
        }
        
        public func cancel() {
            for pipeline in self._pipelines {
                pipeline.cancel()
            }
            self._next.cancel()
        }
        
    }
    
}

private extension Flow.Operator.Fork {
    
    func _receive(pipeline: Pipeline, value: Pipeline.Output.Success) {
        guard let index = self._pipelines.firstIndex(where: { $0 === pipeline }) else { return }
        self._accumulator[index] = .success(value)
    }
    
    func _receive(pipeline: Pipeline, error: Pipeline.Output.Failure) {
        guard let index = self._pipelines.firstIndex(where: { $0 === pipeline }) else { return }
        self._accumulator[index] = .failure(error)
    }
    
    func _result() -> Result< [Pipeline.Output.Success], Pipeline.Output.Failure >? {
        let accumulator = self._accumulator.compactMap({ $0 })
        guard accumulator.count == self._accumulator.count else {
            return nil
        }
        var result: [Pipeline.Output.Success] = []
        for item in accumulator {
            switch item {
            case .success(let value):
                result.append(value)
            case .failure(let error):
                return .failure(error)
            }
        }
        return .success(result)
    }
    
    func _completed() {
        guard let result = self._result() else { return }
        switch result {
        case .success(let value):
            self._next.send(value: value)
        case .failure(let error):
            self._next.send(error: error)
        }
        self._next.completed()
    }
    
}

public extension IFlowBuilder {
    
    func fork<
        Pipelines : Sequence
    >(
        _ pipelines: Pipelines
    ) -> Flow.Chain< Head, Flow.Operator.Fork< Pipelines.Element > > where
        Pipelines.Element : IFlowPipeline,
        Tail.Output == Pipelines.Element.Input
    {
        return self.append(.init(pipelines))
    }
    
}
