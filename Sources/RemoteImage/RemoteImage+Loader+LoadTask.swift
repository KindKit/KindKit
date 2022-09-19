//
//  KindKit
//

import Foundation

extension RemoteImage.Loader {
    
    final class LoadTask : RemoteImage.Loader.Task {
        
        let provider: IApiProvider
        
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
                lockQueue: DispatchQueue(label: "KindKitRemoteImageView.RemoteImageLoader.LoadTask"),
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
        self.task = DispatchWorkItem.async(block: {
            if let image = self.cache.image(query: self.query) {
                self.finish(image: image)
            } else if self.query.isLocal == true {
                do {
                    let data = try self.query.local()
                    if let image = Image(data: data) {
                        try self.cache.set(data: data, image: image, query: self.query)
                        self.finish(image: image)
                    } else {
                        throw NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnknownError)
                    }
                } catch let error {
                    self.finish(error: error)
                }
            } else {
                self.progress(progress: 0)
                self.task = self.query.remote(
                    provider: self.provider,
                    queue: self.workQueue,
                    download: { [unowned self] progress in
                        self.progress(progress: Float(progress.fractionCompleted))
                    },
                    success: { [unowned self] data, image in
                        do {
                            try self.cache.set(data: data, image: image, query: self.query)
                            self.finish(image: image)
                        } catch let error {
                            self.finish(error: error)
                        }
                    },
                    failure: { [unowned self] error in
                        self.finish(error: error)
                    }
                )
            }
        }, queue: self.workQueue)
    }
    
}
