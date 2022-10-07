//
//  KindKit
//

import Foundation

protocol IRemoteImageLoaderTaskDelegate : AnyObject {
    
    func didFinish(_ task: RemoteImage.Loader.Task)
    
}

extension RemoteImage.Loader {
    
    class Task {
        
        weak var delegate: IRemoteImageLoaderTaskDelegate?
        let lockQueue: DispatchQueue
        let workQueue: DispatchQueue
        let syncQueue: DispatchQueue
        let cache: RemoteImage.Cache
        let query: IRemoteImageQuery
        var targets: [IRemoteImageTarget] {
            return self.lockQueue.sync(execute: { self._targets })
        }
        var task: ICancellable? {
            set { self.lockQueue.sync(flags: .barrier, execute: { self._task = newValue }) }
            get { self.lockQueue.sync(execute: { self._task }) }
        }
        
        private var _targets: [IRemoteImageTarget]
        private var _task: ICancellable?
        
        init(
            delegate: IRemoteImageLoaderTaskDelegate,
            lockQueue: DispatchQueue,
            workQueue: DispatchQueue,
            syncQueue: DispatchQueue,
            cache: RemoteImage.Cache,
            query: IRemoteImageQuery,
            target: IRemoteImageTarget
        ) {
            self.delegate = delegate
            self.lockQueue = lockQueue
            self.workQueue = workQueue
            self.syncQueue = syncQueue
            self.cache = cache
            self.query = query
            self._targets = [ target ]
        }
        
        deinit {
            self.cancel()
        }
        
    }
    
}

extension RemoteImage.Loader.Task {
    
    func add(target: IRemoteImageTarget) {
        self.lockQueue.sync(flags: .barrier, execute: {
            self._targets.append(target)
        })
    }
    
    func contains(target: IRemoteImageTarget) -> Bool {
        return self.lockQueue.sync(execute: {
            return self._targets.contains(where: { return $0 === target })
        })
    }
    
    func remove(target: IRemoteImageTarget) -> Bool {
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
    
    func progress(progress: Float) {
        let targets = self.targets
        self.syncQueue.async(execute: {
            for target in targets {
                target.remoteImage(progress: progress)
            }
        })
    }
    
    func finish(image: UI.Image) {
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
