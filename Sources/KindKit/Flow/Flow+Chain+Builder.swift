//
//  KindKit
//

import Foundation

public extension Flow.Chain {

    struct Builder< Head : IFlowOperator, Tail : IFlowOperator > {
        
        public let head: Head
        public let tail: Tail
        
        public init(
            head: Head,
            tail: Tail
        ) {
            self.head = head
            self.tail = tail
        }
        
    }
    
}

public extension Flow.Chain.Builder {
    
    func pipeline() -> Flow.Pipeline< Head.Input, Tail.Output > {
        return Flow.Pipeline(head: self.head, tail: self.tail)
    }
    
    func pipeline(
        onReceive: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> Flow.Pipeline< Head.Input, Tail.Output > {
        let pipeline = self.pipeline()
        _ = pipeline.subscribe(
            onReceive: onReceive,
            onCompleted: onCompleted
        )
        return pipeline
    }
    
    func pipeline(
        onReceiveValue: @escaping (Tail.Output.Success) -> Void,
        onReceiveError: @escaping (Tail.Output.Failure) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> Flow.Pipeline< Head.Input, Tail.Output > {
        let pipeline = self.pipeline()
        _ = pipeline.subscribe(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        )
        return pipeline
    }
    
}
