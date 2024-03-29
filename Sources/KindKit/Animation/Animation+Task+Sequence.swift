//
//  KindKit
//

import Foundation

public extension Animation.Task {
    
    final class Sequence : IAnimationTask {
        
        public var currentIndex: Int
        public let tasks: [IAnimationTask]
        public let completion: (() -> Void)?
        
        public var isRunning: Bool
        public var isCompletion: Bool
        public var isCanceled: Bool
        
        public init(
            tasks: [IAnimationTask],
            completion: (() -> Void)? = nil
        ) {
            self.currentIndex = tasks.startIndex
            self.tasks = tasks
            self.completion = completion
            self.isRunning = false
            self.isCompletion = false
            self.isCanceled = false
        }
        
        public func update(_ delta: TimeInterval) -> Bool {
            guard self.isCompletion == false && self.isCanceled == false else {
                return true
            }
            let lower = self.currentIndex
            let upper = self.tasks.count
            let count = upper - lower
            if count > 0 {
                for index in lower ..< upper {
                    let task = self.tasks[index]
                    if task.update(delta) == true {
                        self.currentIndex = index + 1
                    } else {
                        break
                    }
                }
            }
            return count <= 0
        }
        
        public func complete() {
            guard self.isCompletion == false else { return }
            for task in self.tasks {
                task.complete()
            }
            self.isCompletion = true
            self.completion?()
        }
        
        public func cancel() {
            guard self.isCompletion == false else { return }
            self.isCanceled = true
            for task in self.tasks {
                task.cancel()
            }
        }

    }
    
}

public extension IAnimationTask where Self == Animation.Task.Sequence {
    
    @inlinable
    static func sequence(
        tasks: [IAnimationTask],
        completion: (() -> Void)? = nil
    ) -> Self {
        return .init(
            tasks: tasks,
            completion: completion
        )
    }
    
}
