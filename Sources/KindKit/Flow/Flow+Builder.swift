//
//  KindKit
//

import Foundation

public extension Flow {
    
    struct Builder< Success, Failure > where Failure : Swift.Error {
        
        public typealias Input = Result< Success, Failure >
        
        public init() {
        }
        
    }
    
}

public extension Flow.Builder {
    
    func pipeline() -> Flow.Pipeline< Input, Input > {
        return self.none().pipeline()
    }
    
    func pipeline(
        onReceive: @escaping (Result< Input.Success, Input.Failure >) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> Flow.Pipeline< Input, Input > {
        let pipeline = self.pipeline()
        _ = pipeline.subscribe(
            onReceive: onReceive,
            onCompleted: onCompleted
        )
        return pipeline
    }
    
    func pipeline(
        onReceiveValue: @escaping (Input.Success) -> Void,
        onReceiveError: @escaping (Input.Failure) -> Void,
        onCompleted: (() -> Void)? = nil
    ) -> Flow.Pipeline< Input, Input > {
        let pipeline = self.pipeline()
        _ = pipeline.subscribe(
            onReceiveValue: onReceiveValue,
            onReceiveError: onReceiveError,
            onCompleted: onCompleted
        )
        return pipeline
    }
    
}
