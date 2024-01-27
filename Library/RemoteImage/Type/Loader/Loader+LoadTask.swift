//
//  KindKit
//

import Dispatch
import KindGraphics
import KindNetwork

extension Loader {
    
    final class LoadTask : Loader.Task {
        
        let provider: KindNetwork.Provider
        
        init(
            delegate: ILoaderTaskDelegate,
            workQueue: DispatchQueue,
            syncQueue: DispatchQueue,
            provider: KindNetwork.Provider,
            cache: Cache,
            query: Query,
            targets: [Target]
        ) {
            self.provider = provider
            super.init(
                delegate: delegate,
                lockQueue: DispatchQueue(label: "KindRemoteImage.LoadTask"),
                workQueue: workQueue,
                syncQueue: syncQueue,
                cache: cache,
                query: query,
                targets: targets
            )
            self._perform()
        }
        
        convenience init(
            delegate: ILoaderTaskDelegate,
            workQueue: DispatchQueue,
            syncQueue: DispatchQueue,
            provider: KindNetwork.Provider,
            cache: Cache,
            query: Query
        ) {
            self.init(
                delegate: delegate,
                workQueue: workQueue,
                syncQueue: syncQueue,
                provider: provider,
                cache: cache,
                query: query,
                targets: []
            )
        }
        
        convenience init(
            delegate: ILoaderTaskDelegate,
            workQueue: DispatchQueue,
            syncQueue: DispatchQueue,
            provider: KindNetwork.Provider,
            cache: Cache,
            query: Query,
            target: Target
        ) {
            self.init(
                delegate: delegate,
                workQueue: workQueue,
                syncQueue: syncQueue,
                provider: provider,
                cache: cache,
                query: query,
                targets: [ target ]
            )
        }
        
    }
    
}

extension Loader.LoadTask : @unchecked Sendable {
}

private extension Loader.LoadTask {
    
    func _perform() {
        self.task = DispatchWorkItem.async(queue: self.workQueue, block: {
            if let image = self.cache.image(query: self.query) {
                self.finish(image: image)
            } else if self.query.isLocal == true {
                if let data = try? self.query.local() {
                    if let image = Image(data: data) {
                        try? self.cache.set(data: data, image: image, query: self.query)
                        self.finish(image: image)
                    } else {
                        self.finish(error: .unknown)
                    }
                } else {
                    self.finish(error: .unknown)
                }
            } else {
                self.progress(progress: .min)
                self.task = self.query.remote(
                    provider: self.provider,
                    queue: self.workQueue,
                    download: { [weak self] progress in
                        guard let self = self else { return }
                        self.progress(progress: .init(progress.fractionCompleted))
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
