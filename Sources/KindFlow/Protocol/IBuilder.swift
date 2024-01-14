//
//  KindKit
//

public protocol IBuilder {
    
    associatedtype Head : IOperator
    associatedtype Tail : IOperator
    
    func pipeline() -> Pipeline< Head.Input, Tail.Output >
    
    func append< Operator : IOperator >(_ `operator`: @autoclosure () -> Operator) -> Chain< Head, Operator >
    
}

public extension IBuilder {
    
    func pipeline(
        onReceive: @escaping (Result< Tail.Output.Success, Tail.Output.Failure >) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> Pipeline< Head.Input, Tail.Output > {
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
    ) -> Pipeline< Head.Input, Tail.Output > where Tail.Output.Failure == Never {
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
    ) -> Pipeline< Head.Input, Tail.Output > {
        let pipeline = self.pipeline()
        _ = pipeline.subscribe(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        )
        return pipeline
    }
    
}
