//
//  KindKit
//

import Foundation

public extension Flow.Head {

    struct Builder< Head : IFlowOperator > {
        
        public let head: Head
        
        public init(
            head: Head
        ) {
            self.head = head
        }
        
    }
    
}

public extension Flow.Head.Builder {
    
    func pipeline() -> Flow.Pipeline< Head.Input, Head.Output > {
        return Flow.Pipeline(head: self.head, tail: self.head)
    }
    
    func pipeline(
        onReceive: @escaping (Result< Head.Output.Success, Head.Output.Failure >) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> Flow.Pipeline< Head.Input, Head.Output > {
        let pipeline = self.pipeline()
        _ = pipeline.subscribe(
            onReceive: onReceive,
            onCompleted: onCompleted
        )
        return pipeline
    }
    
    func pipeline(
        onReceiveValue: @escaping (Head.Output.Success) -> Void,
        onReceiveError: @escaping (Head.Output.Failure) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> Flow.Pipeline< Head.Input, Head.Output > {
        let pipeline = self.pipeline()
        _ = pipeline.subscribe(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        )
        return pipeline
    }
    
}
