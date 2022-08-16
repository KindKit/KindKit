//
//  KindKitFlow
//

import Foundation

extension Pipeline {
    
    final class Subscription : IFlowSubscription {
        
        typealias Success = Pipeline.Output.Success
        typealias Failure = Pipeline.Output.Failure
        
        unowned var pipeline: Pipeline?
        
        private let onReceiveValue: (Success) -> Void
        private let onReceiveError: (Failure) -> Void
        private let onCompleted: () -> Void
        
        init(
            pipeline: Pipeline,
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
