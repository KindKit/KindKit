//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitApi
import KindKitView

protocol IRemoteImageLoaderDelegate : AnyObject {
    
    func didFinish(_ task: RemoteImageLoader.Task)
    
}

public class RemoteImageLoader {
    
    public let provider: ApiProvider
    public let cache: RemoteImageCache

    private var _queue: DispatchQueue
    private var _tasks: [Task]

    public init(
        provider: ApiProvider,
        cache: RemoteImageCache,
        queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) throws {
        self.provider = provider
        self.cache = cache
        self._queue = queue
        self._tasks = []
    }
    
}

public extension RemoteImageLoader {
    
    static let shared: RemoteImageLoader = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 30
        sessionConfiguration.timeoutIntervalForResource = 30
        
        let sessionQueue = OperationQueue()
        sessionQueue.maxConcurrentOperationCount = 1
        
        return try! RemoteImageLoader(
            provider: ApiProvider(
                allowInvalidCertificates: true,
                sessionConfiguration: sessionConfiguration,
                sessionQueue: sessionQueue
            ),
            cache: RemoteImageCache.shared
        )
    }()
    
    func isExist(query: IRemoteImageQuery, filter: IRemoteImageFilter? = nil) -> Bool {
        return self.cache.isExist(query: query, filter: filter)
    }

    func download(query: IRemoteImageQuery, filter: IRemoteImageFilter?, target: IRemoteImageTarget) {
        if let task = self._tasks.first(where: { return $0.query.key == query.key && $0.filter?.name == filter?.name }) {
            task.add(target: target)
        } else {
            let task = Task(delegate: self, provider: self.provider, cache: self.cache, query: query, filter: filter, target: target)
            self._tasks.append(task)
            task.execute(queue: self._queue)
        }
    }

    func cancel(target: IRemoteImageTarget) {
        self._tasks.removeAll(where: { task in
            if task.remove(target: target) == true {
                task.cancel()
            }
            return task.isEmptyTargets()
        })
    }
    
    func cleanup(before: TimeInterval) {
        self.cache.cleanup(before: before)
    }
    
}

extension RemoteImageLoader : IRemoteImageLoaderDelegate {
    
    func didFinish(_ task: RemoteImageLoader.Task) {
        self._tasks.removeAll(where: { return $0 === task })
    }
    
}
