//
//  KindKit
//

import Foundation

protocol ILogUITargetObserver : AnyObject {
    
    func append(_ target: LogUI.Target, item: LogUI.Target.Item)
    func remove(_ target: LogUI.Target, item: LogUI.Target.Item)

}

public extension LogUI {

    final class Target : ILogTarget {
            
        public var enabled: Bool
        public let limit: Int
        
        public private(set) var items: [Item]
        
        private var _lastIndex: Int
        private let _observer: Observer< ILogUITargetObserver >
        
        public init(
            enabled: Bool = true,
            limit: Int = 512
        ) {
            self.enabled = enabled
            self.limit = limit
            self.items = []
            self._lastIndex = 0
            self._observer = Observer()
        }
        
        public func log(level: Log.Level, category: String, message: String) {
            guard self.enabled == true else { return }
            let appendItem = Item(index: self._lastIndex, date: Date(), level: level, category: category, message: message)
            self.items.append(appendItem)
            self._lastIndex += 1
            self._observer.notify({ $0.append(self, item: appendItem) })
            if self.items.count > self.limit {
                let removeItem = self.items.removeFirst()
                self._observer.notify({ $0.remove(self, item: removeItem) })
            }
        }

    }

}

public extension LogUI.Target {
    
    struct Item : Equatable {
        
        public let index: Int
        public let date: Date
        public let level: Log.Level
        public let category: String
        public let message: String
        
    }
    
}

extension LogUI.Target {
    
    func add(observer: ILogUITargetObserver, priority: ObserverPriority) {
        self._observer.add(observer, priority: priority)
    }
    
    func remove(observer: ILogUITargetObserver) {
        self._observer.remove(observer)
    }
    
}
