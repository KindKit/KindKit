//
//  KindKit
//

import Foundation

extension RemoteImage.Loader {
    
    final class FilterTask : RemoteImage.Loader.Task {
        
        let filter: IRemoteImageFilter
        
        init(
            delegate: IRemoteImageLoaderTaskDelegate,
            workQueue: DispatchQueue,
            syncQueue: DispatchQueue,
            cache: RemoteImage.Cache,
            query: IRemoteImageQuery,
            filter: IRemoteImageFilter,
            target: IRemoteImageTarget
        ) {
            self.filter = filter
            super.init(
                delegate: delegate,
                lockQueue: DispatchQueue(label: "KindKit.RemoteImage.Loader.FilterTask"),
                workQueue: workQueue,
                syncQueue: syncQueue,
                cache: cache,
                query: query,
                target: target
            )
        }
        
    }
    
}

extension RemoteImage.Loader.FilterTask : IRemoteImageTarget {
    
    func remoteImage(progress: Double) {
        self.progress(progress: progress)
    }
    
    func remoteImage(image: UI.Image) {
        self.task = DispatchWorkItem.kk_async(queue: self.workQueue, block: {
            if let image = self.cache.image(query: self.query, filter: self.filter) {
                self.finish(image: image)
            } else {
                if let image = self.filter.apply(image) {
                    if let data = image.pngData() {
                        try? self.cache.set(data: data, image: image, query: self.query, filter: self.filter)
                        self.finish(image: image)
                    } else {
                        self.finish(error: .unknown)
                    }
                } else {
                    self.finish(error: .unknown)
                }
            }
        })
    }
    
    func remoteImage(error: RemoteImage.Error) {
        self.finish(error: error)
    }
    
}
