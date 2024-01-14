//
//  KindKit
//

import KindMath

public extension Task {
    
    final class Delay : ITask {
        
        public let duration: TimeInterval
        public var elapsed: TimeInterval
        public let completion: (() -> Void)?
        
        public var isRunning: Bool
        public var isCompletion: Bool
        public var isCanceled: Bool
        
        public init(
            duration: TimeInterval,
            elapsed: TimeInterval = 0,
            completion: (() -> Void)? = nil
        ) {
            self.duration = duration
            self.elapsed = elapsed
            self.completion = completion
            self.isRunning = false
            self.isCompletion = false
            self.isCanceled = false
        }
        
        public func update(_ delta: TimeInterval) -> Bool {
            guard self.isCompletion == false && self.isCanceled == false else {
                return true
            }
            self.elapsed += delta
            if self.isRunning == false {
                self.isRunning = true
            }
            return self.elapsed >= self.duration
        }
        
        public func complete() {
            guard self.isCompletion == false else { return }
            self.isCompletion = true
            self.completion?()
        }
        
        public func cancel() {
            guard self.isCompletion == false else { return }
            self.isCanceled = true
        }

    }
    
}

public extension ITask where Self == Task.Delay {
    
    @inlinable
    static func delay(
        duration: TimeInterval,
        elapsed: TimeInterval = 0,
        completion: (() -> Void)? = nil
    ) -> Self {
        return .init(
            duration: duration,
            completion: completion
        )
    }
    
}
