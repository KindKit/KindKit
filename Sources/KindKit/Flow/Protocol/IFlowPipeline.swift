//
//  KindKit
//

import Foundation

public protocol IFlowPipeline : ICancellable {
    
    associatedtype Input : IFlowResult
    associatedtype Output : IFlowResult
    
    func subscribe(
        onReceiveValue: @escaping (Output.Success) -> Void,
        onReceiveError: @escaping (Output.Failure) -> Void,
        onCompleted: @escaping () -> Void
    ) -> IFlowSubscription
    
    func send(value: Input.Success)
    func send(error: Input.Failure)
    
    func completed()
    
}

public extension IFlowPipeline {
    
    @inlinable
    func subscribe(
        onReceiveValue: @escaping (Output.Success) -> Void = { _ in },
        onReceiveError: @escaping (Output.Failure) -> Void = { _ in },
        onCompleted: @escaping () -> Void = {}
    ) -> IFlowSubscription {
        return self.subscribe(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        )
    }
    
}

public extension IFlowPipeline {
    
    @inlinable
    func perform(_ input: Input.Success) {
        self.send(value: input)
        self.completed()
    }
    
}

public extension IFlowPipeline where Input.Success == Void {
    
    @inlinable
    func perform() {
        self.send(value: ())
        self.completed()
    }
    
}
