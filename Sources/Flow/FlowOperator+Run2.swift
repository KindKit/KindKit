//
//  KindKit
//

import Foundation

public extension FlowOperator {
    
    final class Run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    > : IFlowOperator where
        Pipeline1.Input == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        
        public typealias Input = Pipeline1.Input
        public typealias Output = Result< OutputSuccess, Pipeline1.Output.Failure >
        public typealias OutputSuccess = (Pipeline1.Output.Success, Pipeline2.Output.Success)

        private let _pipeline1: Pipeline1
        private let _pipeline2: Pipeline2
        private var _pipelineReceived1: [Result< Pipeline1.Output.Success, Pipeline1.Output.Failure >]
        private var _pipelineReceived2: [Result< Pipeline2.Output.Success, Pipeline2.Output.Failure >]
        private var _subscription1: IFlowSubscription!
        private var _subscription2: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ pipeline1: Pipeline1,
            _ pipeline2: Pipeline2
        ) {
            self._pipeline1 = pipeline1
            self._pipeline2 = pipeline2
            self._pipelineReceived1 = []
            self._pipelineReceived2 = []
            self._subscription1 = pipeline1.subscribe(
                onReceiveValue: { [weak self] in self?._receive1(value: $0) },
                onReceiveError: { [weak self] in self?._receive1(error: $0) },
                onCompleted: { [weak self] in self?._completed() }
            )
            self._subscription2 = pipeline2.subscribe(
                onReceiveValue: { [weak self] in self?._receive2(value: $0) },
                onReceiveError: { [weak self] in self?._receive2(error: $0) },
                onCompleted: { [weak self] in self?._completed() }
            )
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._pipeline1.send(value: value)
            self._pipeline2.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            self._pipeline1.send(error: error)
            self._pipeline2.send(error: error)
        }
        
        public func completed() {
            self._pipeline1.completed()
            self._pipeline2.completed()
        }
        
        public func cancel() {
            self._pipeline1.cancel()
            self._pipeline2.cancel()
            self._next.cancel()
        }
        
    }
    
}

private extension FlowOperator.Run2 {
    
    func _receive1(value: Pipeline1.Output.Success) {
        self._pipelineReceived1.append(.success(value))
    }
    
    func _receive2(value: Pipeline2.Output.Success) {
        self._pipelineReceived2.append(.success(value))
    }
    
    func _receive1(error: Pipeline1.Output.Failure) {
        self._pipelineReceived1.append(.failure(error))
    }
    
    func _receive2(error: Pipeline2.Output.Failure) {
        self._pipelineReceived2.append(.failure(error))
    }
    
    func _completed() {
        guard self._pipelineReceived1.isEmpty == false, self._pipelineReceived1.count == self._pipelineReceived2.count else { return }
        let received1 = self._pipelineReceived1.removeFirst()
        let received2 = self._pipelineReceived2.removeFirst()
        switch (received1, received2) {
        case (.success(let result1), .success(let result2)):
            self._next.send(value: (result1, result2))
        case (.failure(let error1), .success):
            self._next.send(error: error1)
        case (.success, .failure(let error2)):
            self._next.send(error: error2)
        case (.failure(let error1), .failure(let error2)):
            self._next.send(error: error1)
            self._next.send(error: error2)
        }
        self._next.completed()
    }
    
}

extension IFlowOperator {
    
    func run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    >(
        pipeline1: Pipeline1,
        pipeline2: Pipeline2
    ) -> FlowOperator.Run2< Pipeline1, Pipeline2 > where
        Pipeline1.Input == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        let next = FlowOperator.Run2< Pipeline1, Pipeline2 >(pipeline1, pipeline2)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    >(
        pipeline1: Pipeline1,
        pipeline2: Pipeline2
    ) -> FlowBuilder.Head< FlowOperator.Run2< Pipeline1, Pipeline2 > > where
        Input == Pipeline1.Input,
        Pipeline1.Input == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        return .init(head: .init(pipeline1, pipeline2))
    }
    
}

public extension FlowBuilder.Head {
    
    func run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    >(
        pipeline1: Pipeline1,
        pipeline2: Pipeline2
    ) -> FlowBuilder.Chain< Head, FlowOperator.Run2< Pipeline1, Pipeline2 > > where
        Head.Output == Pipeline1.Input,
        Pipeline1.Input == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        return .init(head: self.head, tail: self.head.run2(pipeline1: pipeline1, pipeline2: pipeline2))
    }
}

public extension FlowBuilder.Chain {
    
    func run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    >(
        pipeline1: Pipeline1,
        pipeline2: Pipeline2
    ) -> FlowBuilder.Chain< Head, FlowOperator.Run2< Pipeline1, Pipeline2 > > where
        Head.Output == Pipeline1.Input,
        Pipeline1.Input == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        return .init(head: self.head, tail: self.tail.run2(pipeline1: pipeline1, pipeline2: pipeline2))
    }
    
}
