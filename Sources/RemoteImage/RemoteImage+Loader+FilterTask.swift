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
                lockQueue: DispatchQueue(label: "KindKitRemoteImageView.RemoteImageLoader.FilterTask"),
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
    
    func remoteImage(progress: Float) {
        self.progress(progress: progress)
    }
    
    func remoteImage(image: Image) {
        self.task = DispatchWorkItem.async(block: {
            do {
                if let image = self.filter.apply(image) {
                    if let data = image.pngData() {
                        try self.cache.set(data: data, image: image, query: self.query, filter: self.filter)
                        self.finish(image: image)
                    } else {
                        throw NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnknownError)
                    }
                } else {
                    throw NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnknownError)
                }
            } catch let error {
                self.finish(error: error)
            }
        }, queue: self.workQueue)
    }
    
    func remoteImage(error: Error) {
        self.finish(error: error)
    }
    
}
