//
//  KindKit
//

import Foundation

extension RemoteImage.Loader {
    
    final class LoadTask : RemoteImage.Loader.Task {
        
        let provider: Api.Provider
        
        init(
            delegate: IRemoteImageLoaderTaskDelegate,
            workQueue: DispatchQueue,
            syncQueue: DispatchQueue,
            provider: Api.Provider,
            cache: RemoteImage.Cache,
            query: IRemoteImageQuery,
            target: IRemoteImageTarget
        ) {
            self.provider = provider
            super.init(
                delegate: delegate,
                lockQueue: DispatchQueue(label: "KindKit.RemoteImage.Loader.LoadTask"),
                workQueue: workQueue,
                syncQueue: syncQueue,
                cache: cache,
                query: query,
                target: target
            )
            self._perform()
        }
        
    }
    
}

private extension RemoteImage.Loader.LoadTask {
    
    func _perform() {
        self.task = DispatchWorkItem.kk_async(queue: self.workQueue, block: {
            if let image = self.cache.image(query: self.query) {
                self.finish(image: image)
            } else if self.query.isLocal == true {
                if let data = try? self.query.local() {
                    if let image = UI.Image(data: data) {
                        try? self.cache.set(data: data, image: image, query: self.query)
                        self.finish(image: image)
                    } else {
                        self.finish(error: .unknown)
                    }
                } else {
                    self.finish(error: .unknown)
                }
            } else {
                self.progress(progress: 0)
                self.task = self.query.remote(
                    provider: self.provider,
                    queue: self.workQueue,
                    download: { [weak self] progress in
                        guard let self = self else { return }
                        self.progress(progress: Double(progress.fractionCompleted))
                    },
                    success: { [weak self] data, image in
                        guard let self = self else { return }
                        try? self.cache.set(data: data, image: image, query: self.query)
                        self.finish(image: image)
                    },
                    failure: { [weak self] error in
                        guard let self = self else { return }
                        self.finish(error: error)
                    }
                )
            }
        })
    }
    
}
