//
//  KindKit
//

import Foundation

public extension Animation.Task {
    
    final class Custom : IAnimationTask {
        
        public let delay: TimeInterval
        public let duration: TimeInterval
        public var elapsed: TimeInterval
        public let ease: IAnimationEase
        public let preparing: (() -> Void)?
        public let processing: (_ progress: Percent) -> Void
        public let completion: () -> Void
        
        public var isRunning: Bool
        public var isCompletion: Bool
        public var isCanceled: Bool
        
        public init(
            delay: TimeInterval,
            duration: TimeInterval,
            elapsed: TimeInterval,
            ease: IAnimationEase,
            preparing: (() -> Void)?,
            processing: @escaping (_ progress: Percent) -> Void,
            completion: @escaping () -> Void
        ) {
            self.delay = delay
            self.duration = duration
            self.elapsed = elapsed
            self.ease = ease
            self.preparing = preparing
            self.processing = processing
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
            if self.elapsed > self.delay {
                if self.isRunning == false {
                    self.isRunning = true
                    self.preparing?()
                }
                let progress = Percent((self.elapsed - self.delay) / self.duration).normalized
                self.processing(.init(self.ease.perform(progress.value)))
            }
            return self.elapsed >= self.duration
        }
        
        public func complete() {
            guard self.isCompletion == false else { return }
            self.isCompletion = true
            self.completion()
        }
        
        public func cancel() {
            guard self.isCompletion == false else { return }
            self.isCanceled = true
        }

    }
    
}

public extension IAnimationTask where Self == Animation.Task.Custom {
    
    @inlinable
    static func custom(
        delay: TimeInterval = 0,
        duration: TimeInterval,
        elapsed: TimeInterval = 0,
        ease: IAnimationEase = .linear(),
        preparing: (() -> Void)? = nil,
        processing: @escaping (_ progress: Percent) -> Void,
        completion: @escaping () -> Void
    ) -> Self {
        return .init(
            delay: delay,
            duration: duration,
            elapsed: elapsed,
            ease: ease,
            preparing: preparing,
            processing: processing,
            completion: completion
        )
    }
    
    @inlinable
    static func keyPath< Target : AnyObject, Value : ILerpable >(
        target: Target,
        path: WritableKeyPath< Target, Value >,
        delay: TimeInterval = 0,
        duration: TimeInterval,
        elapsed: TimeInterval = 0,
        ease: IAnimationEase = .linear(),
        to: Value,
        completion: @escaping () -> Void
    ) -> Self {
        let from = target[keyPath: path]
        return .init(
            delay: delay,
            duration: duration,
            elapsed: elapsed,
            ease: ease,
            preparing: nil,
            processing: { [weak target] progress in
                target?[keyPath: path] = from.lerp(to, progress: progress)
            },
            completion: { [weak target] in
                target?[keyPath: path] = to
                completion()
            }
        )
    }
    
}
