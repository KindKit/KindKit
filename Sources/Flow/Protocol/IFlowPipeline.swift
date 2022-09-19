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
