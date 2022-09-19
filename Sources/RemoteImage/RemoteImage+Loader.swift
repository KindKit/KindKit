//
//  KindKit
//

import Foundation

public extension RemoteImage {

    final class Loader {
        
        public let provider: Api.Provider
        public let cache: RemoteImage.Cache

        var lockQueue: DispatchQueue
        var workQueue: DispatchQueue
        var syncQueue: DispatchQueue
        
        private var _loadTasks: [LoadTask]
        private var _filterTasks: [FilterTask]

        public init(
            provider: Api.Provider,
            cache: RemoteImage.Cache = RemoteImage.Cache.shared,
            workQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
            syncQueue: DispatchQueue = DispatchQueue.main
        ) {
            self.provider = provider
            self.cache = cache
            self.lockQueue = DispatchQueue(label: "KindKitRemoteImageView.RemoteImageLoader")
            self.workQueue = workQueue
            self.syncQueue = syncQueue
            self._loadTasks = []
            self._filterTasks = []
        }
        
        deinit {
            for task in self._filterTasks {
                task.cancel()
            }
            for task in self._loadTasks {
                task.cancel()
            }
        }
        
    }
    
}

public extension RemoteImage.Loader {
    
    static let shared: RemoteImage.Loader = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        return RemoteImage.Loader(
            provider: Api.Provider(
                authenticationChallenge: [ .allowUntrusted ],
                configuration: configuration
            )
        )
    }()
    
    func download(target: IRemoteImageTarget, query: IRemoteImageQuery) {
        self.lockQueue.sync(flags: .barrier, execute: {
            if let loadTask = self._loadTasks.first(where: { $0.query.key == query.key }) {
                loadTask.add(target: target)
            } else {
                let loadTask = LoadTask(
                    delegate: self,
                    workQueue: self.workQueue,
                    syncQueue: self.syncQueue,
                    provider: self.provider,
                    cache: self.cache,
                    query: query,
                    target: target
                )
                self._loadTasks.append(loadTask)
            }
        })
    }
    
    func download(target: IRemoteImageTarget, query: IRemoteImageQuery, filter: IRemoteImageFilter) {
        self.lockQueue.sync(flags: .barrier, execute: {
            if let loadTask = self._loadTasks.first(where: { $0.query.key == query.key }) {
                if let filterTask = self._filterTasks.first(where: { $0.query.key == query.key && $0.filter.name == filter.name }) {
                    filterTask.add(target: target)
                } else {
                    let filterTask = FilterTask(
                        delegate: self,
                        workQueue: self.workQueue,
                        syncQueue: self.syncQueue,
                        cache: self.cache,
                        query: query,
                        filter: filter,
                        target: target
                    )
                    loadTask.add(target: filterTask)
                    self._filterTasks.append(filterTask)
                }
            } else {
                let loadTask = LoadTask(
                    delegate: self,
                    workQueue: self.workQueue,
                    syncQueue: self.syncQueue,
                    provider: self.provider,
                    cache: self.cache,
                    query: query,
                    target: target
                )
                let filterTask = FilterTask(
                    delegate: self,
                    workQueue: self.workQueue,
                    syncQueue: self.syncQueue,
                    cache: self.cache,
                    query: query,
                    filter: filter,
                    target: target
                )
                loadTask.add(target: filterTask)
                self._loadTasks.append(loadTask)
                self._filterTasks.append(filterTask)
            }
        })
    }

    func cancel(target: IRemoteImageTarget) {
        self.lockQueue.sync(flags: .barrier, execute: {
            if let index = self._loadTasks.firstIndex(where: { $0.contains(target: target) }) {
                let loadTask = self._loadTasks[index]
                if loadTask.remove(target: target) == true {
                    self._loadTasks.remove(at: index)
                }
            } else if let index = self._filterTasks.firstIndex(where: { $0.contains(target: target) }) {
                let filterTask = self._filterTasks[index]
                if filterTask.remove(target: target) == true {
                    self._filterTasks.remove(at: index)
                }
            }
        })
    }
    
    func cleanup(before: TimeInterval) {
        self.cache.cleanup(before: before)
    }
    
}

extension RemoteImage.Loader : IRemoteImageLoaderTaskDelegate {
    
    func didFinish(_ task: RemoteImage.Loader.Task) {
        self.lockQueue.sync(flags: .barrier, execute: {
            if let index = self._loadTasks.firstIndex(where: { $0 === task }) {
                self._loadTasks.remove(at: index)
            } else if let index = self._filterTasks.firstIndex(where: { $0 === task }) {
                self._filterTasks.remove(at: index)
            }
        })
    }
    
}
