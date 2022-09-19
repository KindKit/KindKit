//
//  KindKit
//

import Foundation

extension FlowPipeline {
    
    final class Subscription : IFlowSubscription {
        
        typealias Success = FlowPipeline.Output.Success
        typealias Failure = FlowPipeline.Output.Failure
        
        unowned var pipeline: FlowPipeline?
        
        private let onReceiveValue: (Success) -> Void
        private let onReceiveError: (Failure) -> Void
        private let onCompleted: () -> Void
        
        init(
            pipeline: FlowPipeline,
            onReceiveValue: @escaping (Success) -> Void,
            onReceiveError: @escaping (Failure) -> Void,
            onCompleted: @escaping () -> Void
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
            self.onCompleted()
        }
        
    }

    
}
