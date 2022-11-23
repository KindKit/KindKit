//
//  KindKit
//

import Foundation

protocol IAnimationQueueDelegate : AnyObject {
    
    func update(_ delta: TimeInterval)
    
}

public final class Animation {
    
    public static let `default` = Animation()
    
    private var _tasks: [IAnimationTask]
    private var _displayLink: DisplayLink
    
    private init() {
        self._tasks = []
        self._displayLink = DisplayLink()
        self._displayLink.delegate = self
    }
    
    deinit {
        self._displayLink.stop()
    }
    
}

public extension Animation {
    
    func append(task: IAnimationTask) {
        guard self._tasks.contains(where: { $0 === task }) == false else {
            return
        }
        self._tasks.append(task)
        if self._displayLink.isRunning == false {
            self._displayLink.start()
        }
    }
    
    func remove(task: IAnimationTask) {
        guard let index = self._tasks.firstIndex(where: { $0 === task }) else {
            return
        }
        task.cancel()
        self._tasks.remove(at: index)
    }
    
    @inlinable
    @discardableResult
    func run(
        _ task: IAnimationTask
    ) -> ICancellable {
        self.append(task: task)
        return task
    }
    
}

extension Animation : IAnimationQueueDelegate {
    
    func update(_ delta: TimeInterval) {
        var removingTask: [IAnimationTask] = []
        for task in self._tasks {
            if task.update(delta) == true {
                removingTask.append(task)
            }
        }
        if removingTask.count > 0 {
            self._tasks.removeAll(where: { task in
                return removingTask.contains(where: { return task === $0 })
            })
            for task in removingTask {
                task.complete()
            }
        }
        if self._tasks.count == 0 {
            self._displayLink.stop()
        }
    }
    
}
