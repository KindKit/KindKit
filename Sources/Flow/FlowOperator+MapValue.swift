//
//  KindKit
//

import Foundation

public extension FlowOperator {
    
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
    
    func mapValue< Transform >(
        _ perform: @escaping (Output.Success) -> Transform
    ) -> FlowOperator.MapValue< Output, Transform > {
        let next = FlowOperator.MapValue< Output, Transform >(perform)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func mapValue< Transform >(
        _ perform: @escaping (Input.Success) -> Transform
    ) -> FlowBuilder.Head< FlowOperator.MapValue< Input, Transform > > {
        return .init(head: .init(perform))
    }
    
}

public extension FlowBuilder.Head {
    
    func mapValue< Transform >(
        _ perform: @escaping (Head.Output.Success) -> Transform
    ) -> FlowBuilder.Chain< Head, FlowOperator.MapValue< Head.Output, Transform > > {
        return .init(head: self.head, tail: self.head.mapValue(perform))
    }
}

public extension FlowBuilder.Chain {
    
    func mapValue< Transform >(
        _ perform: @escaping (Tail.Output.Success) -> Transform
    ) -> FlowBuilder.Chain< Head, FlowOperator.MapValue< Tail.Output, Transform > > {
        return .init(head: self.head, tail: self.tail.mapValue(perform))
    }
    
}
