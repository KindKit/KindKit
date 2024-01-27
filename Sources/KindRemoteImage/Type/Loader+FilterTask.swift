//
//  KindKit
//

import Dispatch
import KindGraphics
import KindTime

extension Loader {
    
    final class FilterTask : Loader.Task {
        
        let filter: IFilter
        
        init(
            delegate: ILoaderTaskDelegate,
            workQueue: DispatchQueue,
            syncQueue: DispatchQueue,
            cache: Cache,
            query: IQuery,
            filter: IFilter,
            target: ITarget
        ) {
            self.filter = filter
            super.init(
                delegate: delegate,
                lockQueue: DispatchQueue(label: "KindKit.Loader.FilterTask"),
                workQueue: workQueue,
                syncQueue: syncQueue,
                cache: cache,
                query: query,
                targets: [ target ]
            )
        }
        
    }
    
}

extension Loader.FilterTask : ITarget {
    
    func remoteImage(progress: Double) {
        self.progress(progress: progress)
    }
    
    func remoteImage(image: Image) {
        self.task = DispatchWorkItem.async(queue: self.workQueue, block: {
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
    
    func remoteImage(error: Error) {
        self.finish(error: error)
    }
    
}
