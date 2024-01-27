//
//  KindKit
//

import Foundation
import KindGraphics

protocol ILoaderTaskDelegate : AnyObject {
    
    func didFinish(_ task: Loader.Task)
    
}

extension Loader {
    
    class Task {
        
        weak var delegate: ILoaderTaskDelegate?
        let lockQueue: DispatchQueue
        let workQueue: DispatchQueue
        let syncQueue: DispatchQueue
        let cache: Cache
        let query: IQuery
        var targets: [ITarget] {
            return self.lockQueue.sync(execute: { self._targets })
        }
        var task: ICancellable? {
            set { self.lockQueue.sync(flags: .barrier, execute: { self._task = newValue }) }
            get { self.lockQueue.sync(execute: { self._task }) }
        }
        
        private var _targets: [ITarget]
        private var _task: ICancellable?
        
        init(
            delegate: ILoaderTaskDelegate,
            lockQueue: DispatchQueue,
            workQueue: DispatchQueue,
            syncQueue: DispatchQueue,
            cache: Cache,
            query: IQuery,
            targets: [ITarget]
        ) {
            self.delegate = delegate
            self.lockQueue = lockQueue
            self.workQueue = workQueue
            self.syncQueue = syncQueue
            self.cache = cache
            self.query = query
            self._targets = targets
        }
        
        deinit {
            self.cancel()
        }
        
    }
    
}

extension Loader.Task {
    
    func add(target: ITarget) {
        self.lockQueue.sync(flags: .barrier, execute: {
            self._targets.append(target)
        })
    }
    
    func contains(target: ITarget) -> Bool {
        return self.lockQueue.sync(execute: {
            return self._targets.contains(where: { return $0 === target })
        })
    }
    
    func remove(target: ITarget) -> Bool {
        return self.lockQueue.sync(flags: .barrier, execute: {
            if let index = self._targets.firstIndex(where: { return $0 === target }) {
                self._targets.remove(at: index)
            }
            if self._targets.isEmpty == true {
                self._task?.cancel()
                self._task = nil
            }
            return self._targets.isEmpty
        })
    }
    
    func progress(progress: Double) {
        let targets = self.targets
        self.syncQueue.async(execute: {
            for target in targets {
                target.remoteImage(progress: progress)
            }
        })
    }
    
    func finish(image: Image) {
        self.task = nil
        self.syncQueue.async(execute: {
            self.delegate?.didFinish(self)
            for target in self.targets {
                target.remoteImage(image: image)
            }
        })
    }
    
    func finish(error: Error) {
        self.task = nil
        self.syncQueue.async(execute: {
            self.delegate?.didFinish(self)
            for target in self.targets {
                target.remoteImage(error: error)
            }
        })
    }
    
    func cancel() {
        self.lockQueue.sync(flags: .barrier, execute: {
            self._task?.cancel()
            self._task = nil
        })
    }
    
}
