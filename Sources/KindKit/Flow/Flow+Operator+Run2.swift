//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
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
        private var _received1: [Result< Pipeline1.Output.Success, Pipeline1.Output.Failure >] = []
        private var _received2: [Result< Pipeline2.Output.Success, Pipeline2.Output.Failure >] = []
        private var _subscription1: IFlowSubscription!
        private var _subscription2: IFlowSubscription!
        private var _next: IFlowPipe!
        
        init(
            _ pipeline1: Pipeline1,
            _ pipeline2: Pipeline2
        ) {
            self._pipeline1 = pipeline1
            self._pipeline2 = pipeline2
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

private extension Flow.Operator.Run2 {
    
    func _receive1(value: Pipeline1.Output.Success) {
        self._received1.append(.success(value))
    }
    
    func _receive2(value: Pipeline2.Output.Success) {
        self._received2.append(.success(value))
    }
    
    func _receive1(error: Pipeline1.Output.Failure) {
        self._received1.append(.failure(error))
    }
    
    func _receive2(error: Pipeline2.Output.Failure) {
        self._received2.append(.failure(error))
    }
    
    func _completed() {
        guard self._received1.isEmpty == false else { return }
        guard self._received1.count == self._received2.count else { return }
        let received1 = self._received1.removeFirst()
        let received2 = self._received2.removeFirst()
        switch (received1, received2) {
        case (.success(let result1), .success(let result2)):
            self._next.send(value: (result1, result2))
        case (.failure(let error), _):
            self._next.send(error: error)
        case (_, .failure(let error)):
            self._next.send(error: error)
        }
        self._next.completed()
    }
    
}

extension IFlowOperator {
    
    func run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    >(
        _ pipeline1: Pipeline1,
        _ pipeline2: Pipeline2
    ) -> Flow.Operator.Run2< Pipeline1, Pipeline2 > where
        Pipeline1.Input == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        let next = Flow.Operator.Run2< Pipeline1, Pipeline2 >(pipeline1, pipeline2)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    >(
        pipeline1: Pipeline1,
        pipeline2: Pipeline2
    ) -> Flow.Head.Builder< Flow.Operator.Run2< Pipeline1, Pipeline2 > > where
        Input == Pipeline1.Input,
        Input == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        return .init(head: .init(pipeline1, pipeline2))
    }
    
}

public extension Flow.Head.Builder {
    
    func run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    >(
        pipeline1: Pipeline1,
        pipeline2: Pipeline2
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Run2< Pipeline1, Pipeline2 > > where
        Head.Output == Pipeline1.Input,
        Head.Output == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        return .init(head: self.head, tail: self.head.run2(pipeline1, pipeline2))
    }
}

public extension Flow.Chain.Builder {
    
    func run2<
        Pipeline1 : IFlowPipeline,
        Pipeline2 : IFlowPipeline
    >(
        pipeline1: Pipeline1,
        pipeline2: Pipeline2
    ) -> Flow.Chain.Builder< Head, Flow.Operator.Run2< Pipeline1, Pipeline2 > > where
        Tail.Output == Pipeline1.Input,
        Tail.Output == Pipeline2.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure
    {
        return .init(head: self.head, tail: self.tail.run2(pipeline1, pipeline2))
    }
    
}
