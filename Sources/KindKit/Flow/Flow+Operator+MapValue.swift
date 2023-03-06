//
//  KindKit
//

import Foundation

public extension Flow.Operator {
    
    final class MapValue< Input : IFlowResult, Transform > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Transform, Input.Failure >
        
        private let _perform: (Input.Success) -> Transform
        private var _next: IFlowPipe!
        
        init(
            _ perform: @escaping (Input.Success) -> Transform
        ) {
            self._perform = perform
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._next.send(value: self._perform(value))
        }
        
        public func receive(error: Input.Failure) {
            self._next.send(error: error)
        }
        
        public func completed() {
            self._next.completed()
        }
        
        public func cancel() {
            self._next.cancel()
        }
        
    }
    
}

extension IFlowOperator {
    
    func mapValue<
        Transform
    >(
        _ perform: @escaping (Output.Success) -> Transform
    ) -> Flow.Operator.MapValue< Output, Transform > {
        let next = Flow.Operator.MapValue< Output, Transform >(perform)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func mapValue<
        Transform
    >(
        _ perform: @escaping (Input.Success) -> Transform
    ) -> Flow.Head.Builder< Flow.Operator.MapValue< Input, Transform > > {
        return .init(head: .init(perform))
    }
    
}

public extension Flow.Head.Builder {
    
    func mapValue<
        Transform
    >(
        _ perform: @escaping (Head.Output.Success) -> Transform
    ) -> Flow.Chain.Builder< Head, Flow.Operator.MapValue< Head.Output, Transform > > {
        return .init(head: self.head, tail: self.head.mapValue(perform))
    }
}

public extension Flow.Chain.Builder {
    
    func mapValue<
        Transform
    >(
        _ perform: @escaping (Tail.Output.Success) -> Transform
    ) -> Flow.Chain.Builder< Head, Flow.Operator.MapValue< Tail.Output, Transform > > {
        return .init(head: self.head, tail: self.tail.mapValue(perform))
    }
    
}
