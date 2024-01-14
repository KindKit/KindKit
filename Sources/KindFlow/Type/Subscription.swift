//
//  KindKit
//

import Foundation

final class Subscription< InputType : IResult, OutputType : IResult > : ISubscription {
    
    typealias Success = OutputType.Success
    typealias Failure = OutputType.Failure
    
    weak var pipeline: Pipeline< InputType, OutputType >?
    
    private let onReceiveValue: (Success) -> Void
    private let onReceiveError: (Failure) -> Void
    private let onCompleted: (() -> Void)?
    
    init(
        pipeline: Pipeline< InputType, OutputType >,
        onReceiveValue: @escaping (Success) -> Void,
        onReceiveError: @escaping (Failure) -> Void,
        onCompleted: (() -> Void)?
    ) {
        self.pipeline = pipeline
        self.onReceiveValue = onReceiveValue
        self.onReceiveError = onReceiveError
        self.onCompleted = onCompleted
    }
    
    deinit {
        self.cancel()
    }
    
    func cancel() {
        guard let pipeline = self.pipeline else { return }
        pipeline.unsubscribe(self)
        self.pipeline = nil
    }

    func receive(value: Success) {
        self.onReceiveValue(value)
    }
    
    func receive(error: Failure) {
        self.onReceiveError(error)
    }
    
    func completed() {
        self.onCompleted?()
    }
    
}
