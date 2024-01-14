//
//  KindKit
//

import Foundation

public extension Operator {
    
    final class Fork3< Pipeline1 : IPipeline, Pipeline2 : IPipeline, Pipeline3 : IPipeline > : IOperator where
        Pipeline1.Input == Pipeline2.Input,
        Pipeline1.Input == Pipeline3.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure,
        Pipeline1.Output.Failure == Pipeline3.Output.Failure
    {
        
        public typealias Input = Pipeline1.Input
        public typealias Output = Result< OutputSuccess, Pipeline1.Output.Failure >
        public typealias OutputSuccess = (Pipeline1.Output.Success, Pipeline2.Output.Success, Pipeline3.Output.Success)

        private let _pipeline1: Pipeline1
        private let _pipeline2: Pipeline2
        private let _pipeline3: Pipeline3
        private var _accumulator1: [Result< Pipeline1.Output.Success, Pipeline1.Output.Failure >] = []
        private var _accumulator2: [Result< Pipeline2.Output.Success, Pipeline2.Output.Failure >] = []
        private var _accumulator3: [Result< Pipeline3.Output.Success, Pipeline3.Output.Failure >] = []
        private var _subscription1: ISubscription!
        private var _subscription2: ISubscription!
        private var _subscription3: ISubscription!
        private var _next: IPipe!
        
        init(
            _ pipeline1: Pipeline1,
            _ pipeline2: Pipeline2,
            _ pipeline3: Pipeline3
        ) {
            self._pipeline1 = pipeline1
            self._pipeline2 = pipeline2
            self._pipeline3 = pipeline3
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
            self._subscription3 = pipeline3.subscribe(
                onReceiveValue: { [weak self] in self?._receive3(value: $0) },
                onReceiveError: { [weak self] in self?._receive3(error: $0) },
                onCompleted: { [weak self] in self?._completed() }
            )
        }
        
        public func subscribe(next: IPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._pipeline1.send(value: value)
            self._pipeline2.send(value: value)
            self._pipeline3.send(value: value)
        }
        
        public func receive(error: Input.Failure) {
            self._pipeline1.send(error: error)
            self._pipeline2.send(error: error)
            self._pipeline3.send(error: error)
        }
        
        public func completed() {
            self._pipeline1.completed()
            self._pipeline2.completed()
            self._pipeline3.completed()
        }
        
        public func cancel() {
            self._pipeline1.cancel()
            self._pipeline2.cancel()
            self._pipeline3.cancel()
            self._next.cancel()
        }
        
    }
    
}

private extension Operator.Fork3 {
    
    func _receive1(value: Pipeline1.Output.Success) {
        self._accumulator1.append(.success(value))
    }
    
    func _receive2(value: Pipeline2.Output.Success) {
        self._accumulator2.append(.success(value))
    }
    
    func _receive3(value: Pipeline3.Output.Success) {
        self._accumulator3.append(.success(value))
    }
    
    func _receive1(error: Pipeline1.Output.Failure) {
        self._accumulator1.append(.failure(error))
    }
    
    func _receive2(error: Pipeline2.Output.Failure) {
        self._accumulator2.append(.failure(error))
    }
    
    func _receive3(error: Pipeline3.Output.Failure) {
        self._accumulator3.append(.failure(error))
    }
    
    func _completed() {
        guard self._accumulator1.isEmpty == false else { return }
        guard self._accumulator1.count == self._accumulator2.count else { return }
        guard self._accumulator2.count == self._accumulator3.count else { return }
        let accumulator1 = self._accumulator1.removeFirst()
        let accumulator2 = self._accumulator2.removeFirst()
        let accumulator3 = self._accumulator3.removeFirst()
        switch (accumulator1, accumulator2, accumulator3) {
        case (.success(let result1), .success(let result2), .success(let result3)):
            self._next.send(value: (result1, result2, result3))
        case (.failure(let error), _, _):
            self._next.send(error: error)
        case (_, .failure(let error), _):
            self._next.send(error: error)
        case (_, _, .failure(let error)):
            self._next.send(error: error)
        }
        self._next.completed()
    }
    
}

public extension IBuilder {
    
    func fork<
        Pipeline1 : IPipeline,
        Pipeline2 : IPipeline,
        Pipeline3 : IPipeline
    >(
        pipeline1: Pipeline1,
        pipeline2: Pipeline2,
        pipeline3: Pipeline3
    ) -> Chain< Head, Operator.Fork3< Pipeline1, Pipeline2, Pipeline3 > > where
        Tail.Output == Pipeline1.Input,
        Tail.Output == Pipeline2.Input,
        Tail.Output == Pipeline3.Input,
        Pipeline1.Output.Failure == Pipeline2.Output.Failure,
        Pipeline1.Output.Failure == Pipeline3.Output.Failure
    {
        return self.append(.init(pipeline1, pipeline2, pipeline3))
    }
    
}
