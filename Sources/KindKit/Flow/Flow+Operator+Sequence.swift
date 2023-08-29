//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class Sequence<
        Pipeline : IFlowPipeline
    > : IFlowOperator {
        
        public typealias Input = Pipeline.Input
        public typealias Output = Result< [Pipeline.Output.Success], Pipeline.Output.Failure >

        private let _pipelines: [Pipeline]
        private var _received: Result< Input.Success, Input.Failure >?
        private var _accumulator: [Result< Pipeline.Output.Success, Pipeline.Output.Failure >?] = []
        private var _activePipeline: Pipeline?
        private var _activeSubscription: ICancellable?
        private var _next: IFlowPipe!
        
        init< Pipelines : Swift.Sequence >(
            _ pipelines: Pipelines
        ) where Pipelines.Element == Pipeline {
            self._pipelines = .init(pipelines)
            self._accumulator = .init(repeating: nil, count: self._pipelines.count)
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._received = .success(value)
        }
        
        public func receive(error: Input.Failure) {
            self._received = .failure(error)
        }
        
        public func completed() {
            if self._activePipeline == nil && self._pipelines.isEmpty == false {
                self._active(pipeline: self._pipelines.startIndex, send: self._received)
            } else {
                self._next.completed()
            }
        }
        
        public func cancel() {
            for pipeline in self._pipelines {
                pipeline.cancel()
            }
            self._received = nil
            for index in self._accumulator.indices {
                self._accumulator[index] = nil
            }
            self._activePipeline = nil
            self._activeSubscription = nil
            self._next.cancel()
        }
        
    }
    
}

private extension Flow.Operator.Sequence {
    
    func _active(pipeline index: Int, send: Result< Input.Success, Input.Failure >?) {
        let pipeline = self._pipelines[index]
        self._activePipeline = pipeline
        self._activeSubscription = pipeline.subscribe(onReceiveValue: { [weak self] in
            self?._receive(pipeline: index, value: $0)
        }, onReceiveError: { [weak self] in
            self?._receive(pipeline: index, error: $0)
        }, onCompleted: { [weak self] in
            self?._completed(pipeline: index)
        }).autoCancel()
        if let send = send {
            pipeline.send(send)
        }
        pipeline.completed()
    }
    
    func _result() -> Result< [Pipeline.Output.Success], Pipeline.Output.Failure > {
        var result: [Pipeline.Output.Success] = []
        for item in self._accumulator {
            switch item {
            case .success(let value):
                result.append(value)
            case .failure(let error):
                return .failure(error)
            case .none:
                break
            }
        }
        return .success(result)
    }
    
    func _receive(pipeline index: Int, value: Pipeline.Output.Success) {
        self._accumulator[index] = .success(value)
    }
    
    func _receive(pipeline index: Int, error: Pipeline.Output.Failure) {
        self._accumulator[index] = .failure(error)
    }
    
    func _completed(pipeline index: Int) {
        if index == self._pipelines.endIndex - 1 {
            self._activePipeline = nil
            self._activeSubscription = nil
            switch self._result() {
            case .success(let value):
                self._next.send(value: value)
            case .failure(let error):
                self._next.send(error: error)
            }
            self._next.completed()
        } else {
            self._active(pipeline: index + 1, send: self._received)
        }
    }
    
}

public extension IFlowBuilder {
    
    func sequence<
        Pipelines : Sequence
    >(
        _ pipelines: Pipelines
    ) -> Flow.Chain< Head, Flow.Operator.Sequence< Pipelines.Element > > where
        Pipelines.Element : IFlowPipeline,
        Tail.Output == Pipelines.Element.Input
    {
        return self.append(.init(pipelines))
    }
    
}
