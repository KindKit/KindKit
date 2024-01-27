//
//  KindKit
//

import Foundation
import KindNetwork
import KindTime

public final class Loader {
    
    public let provider: Provider
    public let cache: Cache

    public let lockQueue: DispatchQueue
    public let workQueue: DispatchQueue
    public let syncQueue: DispatchQueue
    
    private var _loadTasks: [LoadTask]
    private var _filterTasks: [FilterTask]

    public init(
        provider: Provider,
        cache: Cache = .shared,
        workQueue: DispatchQueue = .global(qos: .userInitiated),
        syncQueue: DispatchQueue = .main
    ) {
        self.provider = provider
        self.cache = cache
        self.lockQueue = DispatchQueue(label: "KindKit.Loader")
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

public extension Loader {
    
    static let shared = Loader(
        provider: .default()
    )
    
    static let background = Loader(
        provider: .default(),
        syncQueue: .global(qos: .utility)
    )
    
    func download(target: ITarget, query: IQuery, filter: IFilter? = nil) {
        if let filter = filter {
            self.lockQueue.async(execute: {
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
                } else if let image = self.cache.image(query: query, filter: filter) {
                    self.syncQueue.async(execute: {
                        target.remoteImage(image: image)
                    })
                } else {
                    let loadTask = LoadTask(
                        delegate: self,
                        workQueue: self.workQueue,
                        syncQueue: self.syncQueue,
                        provider: self.provider,
                        cache: self.cache,
                        query: query
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
        } else {
            self.lockQueue.async(execute: {
                if let loadTask = self._loadTasks.first(where: { $0.query.key == query.key }) {
                    loadTask.add(target: target)
                } else if let image = self.cache.image(query: query) {
                    self.syncQueue.async(execute: {
                        target.remoteImage(image: image)
                    })
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
    }

    func cancel(target: ITarget) {
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
    
    func cleanup(before: SecondsInterval) {
        self.cache.cleanup(before: before)
    }
    
}

extension Loader : ILoaderTaskDelegate {
    
    func didFinish(_ task: Loader.Task) {
        self.lockQueue.sync(flags: .barrier, execute: {
            if let index = self._loadTasks.firstIndex(where: { $0 === task }) {
                self._loadTasks.remove(at: index)
            } else if let index = self._filterTasks.firstIndex(where: { $0 === task }) {
                self._filterTasks.remove(at: index)
            }
        })
    }
    
}

fileprivate extension KindNetwork.Provider {
    
    static func `default`() -> Self {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        return .init(
            authenticationChallenge: .allowUntrusted,
            configuration: configuration
        )
    }
    
}
