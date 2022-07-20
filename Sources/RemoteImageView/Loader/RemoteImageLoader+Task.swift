//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitApi
import KindKitView

extension RemoteImageLoader {
    
    final class Task {
        
        var query: IRemoteImageQuery
        var filter: IRemoteImageFilter?

        private unowned var _delegate: IRemoteImageLoaderDelegate
        private var _provider: IApiProvider
        private var _cache: RemoteImageCache
        private var _targets: [IRemoteImageTarget]
        private var _workItem: DispatchWorkItem?
        private var _cancellable: ICancellable?
        
        init(
            delegate: IRemoteImageLoaderDelegate,
            provider: ApiProvider,
            cache: RemoteImageCache,
            query: IRemoteImageQuery,
            filter: IRemoteImageFilter?,
            target: IRemoteImageTarget
        ) {
            self._delegate = delegate
            self._provider = provider
            self._cache = cache
            self.query = query
            self.filter = filter
            self._targets = [ target ]
        }
        
    }
    
}

extension RemoteImageLoader.Task {
    
    func add(target: IRemoteImageTarget) {
        self._targets.append(target)
    }
    
    func remove(target: IRemoteImageTarget) -> Bool {
        guard let index = self._targets.firstIndex(where: { return $0 === target }) else {
            return false
        }
        self._targets.remove(at: index)
        return true
    }
    
    func isEmptyTargets() -> Bool {
        return self._targets.isEmpty
    }
    
    func execute(queue: DispatchQueue) {
        var workItem: DispatchWorkItem
        if self._cache.isExist(query: self.query, filter: self.filter) == true {
            workItem = self._cacheWorkItem()
        } else if self._cache.isExist(query: self.query) == true {
            workItem = self._cacheWorkItem()
        } else if self.query.isLocal == true {
            workItem = self._localWorkItem()
        } else {
            workItem = self._remoteWorkItem()
        }
        self._workItem = workItem
        queue.async(execute: workItem)
    }
    
    func cancel() {
        if let workItem = self._workItem {
            workItem.cancel()
            self._workItem = nil
        }
        if let cancellable = self._cancellable {
            cancellable.cancel()
            self._cancellable = nil
        }
    }
    
    
}

private extension RemoteImageLoader.Task {
    
    func _cacheWorkItem() -> DispatchWorkItem {
        return DispatchWorkItem(block: { [weak self] in
            guard let self = self, let workItem = self._workItem else { return }
            var resultImage = self._cache.image(query: self.query, filter: self.filter)
            var resultError: Error?
            if resultImage == nil {
                if workItem.isCancelled == false, let filter = self.filter {
                    if workItem.isCancelled == false, let originImage = self._cache.image(query: self.query), let image = filter.apply(originImage) {
                        if workItem.isCancelled == false, let data = image.pngData() {
                            do {
                                try self._cache.set(data: data, image: image, query: self.query, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    }
                }
            }
            self._finish(workItem: workItem, image: resultImage, error: resultError)
        })
    }
    
    func _localWorkItem() -> DispatchWorkItem {
        return DispatchWorkItem(block: { [weak self] in
            guard let self = self, let workItem = self._workItem else { return }
            var resultImage: Image?
            var resultError: Error?
            do {
                let data = try self.query.localData()
                if workItem.isCancelled == false, let originImage = Image(data: data) {
                    try self._cache.set(data: data, image: originImage, query: self.query)
                    if workItem.isCancelled == false, let filter = self.filter, let image = filter.apply(originImage) {
                        if workItem.isCancelled == false, let data = image.pngData() {
                            do {
                                try self._cache.set(data: data, image: image, query: self.query, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    } else if workItem.isCancelled == false {
                        resultImage = originImage
                    }
                }
            } catch let error {
                resultError = error
            }
            self._finish(workItem: workItem, image: resultImage, error: resultError)
        })
    }
    
    func _remoteWorkItem() -> DispatchWorkItem {
        let semaphore = DispatchSemaphore(value: 0)
        return DispatchWorkItem(block: { [weak self] in
            guard let self = self, let workItem = self._workItem else { return }
            var downloadData: Data?
            var downloadImage: Image?
            var resultImage: Image?
            var resultError: Error?
            self._progress(progress: Progress(totalUnitCount: 0))
            self._cancellable = self.query.download(
                provider: self._provider,
                download: { [weak self] progress in
                    self?._progress(progress: progress)
                },
                success: { data, image in
                    downloadData = data
                    downloadImage = image
                    semaphore.signal()
                },
                failure: { error in
                    resultError = error
                    semaphore.signal()
                }
            )
            while true {
                if workItem.isCancelled == true {
                    break
                }
                if semaphore.wait(timeout: .now() + .milliseconds(10)) == .success {
                    break
                }
            }
            if workItem.isCancelled == false, let data = downloadData, let originImage = downloadImage {
                do {
                    try self._cache.set(data: data, image: originImage, query: self.query)
                    if workItem.isCancelled == false, let filter = self.filter, let image = filter.apply(originImage) {
                        if workItem.isCancelled == false, let data = image.pngData() {
                            do {
                                try self._cache.set(data: data, image: image, query: self.query, filter: filter)
                                resultImage = image
                            } catch let error {
                                resultError = error
                            }
                        }
                    } else if workItem.isCancelled == false {
                        resultImage = originImage
                    }
                } catch let error {
                    resultError = error
                }
            }
            self._finish(workItem: workItem, image: resultImage, error: resultError)
        })
    }
    
    func _progress(progress: Progress) {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            for target in self._targets {
                target.remoteImage(progress: Float(progress.fractionCompleted))
            }
        })
    }
    
    func _finish(workItem: DispatchWorkItem, image: Image?, error: Error?) {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            self._delegate.didFinish(self)
            self._cancellable = nil
            self._workItem = nil
            if workItem.isCancelled == false {
                if let image = image {
                    for target in self._targets {
                        target.remoteImage(image: image)
                    }
                } else if let error = error {
                    for target in self._targets {
                        target.remoteImage(error: error)
                    }
                }
            }
        })
    }
    
}
