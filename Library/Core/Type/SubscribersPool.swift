//
//  KindKit
//

import Foundation

public final class SubscribersPool {
    
    private(set) var subscribers: [CancelTrait] = []
    
    public init() {
    }
    
    deinit {
        self.cancel()
    }
    
}

public extension SubscribersPool {
    
    func append(_ subscriber: CancelTrait) {
        self.subscribers.append(subscriber)
    }
    
    @inlinable
    func append(_ subscribers: [CancelTrait]) {
        for subscriber in subscribers {
            self.append(subscriber)
        }
    }
    
    func remove(_ subscriber: CancelTrait) {
        guard let index = self.subscribers.firstIndex(where: { $0 === subscriber }) else { return }
        self.subscribers.remove(at: index)
    }
    
    func reset() {
        self.cancel()
    }
    
}

extension SubscribersPool : CancelTrait {
    
    public func cancel() {
        for subscriber in self.subscribers {
            subscriber.cancel()
        }
        self.subscribers.removeAll(keepingCapacity: true)
    }

}
