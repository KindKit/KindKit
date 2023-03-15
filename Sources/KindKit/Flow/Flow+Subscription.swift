//
//  KindKit
//

import Foundation

extension Flow {
    
    final class Subscription< Input : IFlowResult, Output : IFlowResult > : IFlowSubscription {
        
        typealias Success = Output.Success
        typealias Failure = Output.Failure
        typealias Pipeline = Flow.Pipeline< Input, Output >
        
        weak var pipeline: Pipeline?
        
        private let onReceiveValue: (Success) -> Void
        private let onReceiveError: (Failure) -> Void
        private let onCompleted: (() -> Void)?
        
        init(
            pipeline: Pipeline,
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

    
}
