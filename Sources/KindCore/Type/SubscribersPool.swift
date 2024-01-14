//
//  KindKit
//

import Foundation

public final class SubscribersPool {
    
    private(set) var subscribers: [ICancellable] = []
    
    public init() {
    }
    
    deinit {
        self.cancel()
    }
    
}

public extension SubscribersPool {
    
    func append(_ subscriber: ICancellable) {
        self.subscribers.append(subscriber)
    }
    
    @inlinable
    func append(_ subscribers: [ICancellable]) {
        for subscriber in subscribers {
            self.append(subscriber)
        }
    }
    
    func remove(_ subscriber: ICancellable) {
        guard let index = self.subscribers.firstIndex(where: { $0 === subscriber }) else { return }
        self.subscribers.remove(at: index)
    }
    
    func reset() {
        self.cancel()
    }
    
}

extension SubscribersPool : ICancellable {
    
    public func cancel() {
        for subscriber in self.subscribers {
            subscriber.cancel()
        }
        self.subscribers.removeAll(keepingCapacity: true)
    }

}
