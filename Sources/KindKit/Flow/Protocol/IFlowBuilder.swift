//
//  KindKit
//

import Foundation

public protocol IFlowBuilder {
    
    associatedtype Head : IFlowOperator
    associatedtype Tail : IFlowOperator
    
    func pipeline() -> Flow.Pipeline< Head.Input, Tail.Output >
    
    func append< Operator : IFlowOperator >(_ `operator`: @autoclosure () -> Operator) -> Flow.Chain< Head, Operator >
    
}

public extension IFlowBuilder {
    
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
        onReceive: @escaping (Tail.Output.Success) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> Flow.Pipeline< Head.Input, Tail.Output > where Tail.Output.Failure == Never {
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
