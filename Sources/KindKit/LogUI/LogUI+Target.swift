//
//  KindKit
//

import Foundation

protocol ILogUITargetObserver : AnyObject {
    
    func append(_ target: LogUI.Target, message: Log.Message)
    func remove(_ target: LogUI.Target, message: Log.Message)

}

public extension LogUI {

    final class Target {
        
        public let limit: Int
        var messages: [Log.Message] {
            return self._queue.sync(flags: .barrier, execute: {
                return self._messages
            })
        }

        private var _messages: [Log.Message]
        private let _queue: DispatchQueue
        private let _observer: Observer< ILogUITargetObserver >
        
        public init(
            limit: Int = 512
        ) {
            self.limit = limit
            self._messages = []
            self._queue = .init(label: "KindKit.LogUI.Target")
            self._observer = Observer()
        }

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

extension LogUI.Target : ILogTarget {
    
    public var files: [URL] {
        return []
    }
    
    public func log(message: Log.Message) {
        self._queue.async(execute: { [weak self] in
            guard let self = self else { return }
            self._log(message: message)
        })
        
    }
    
}

private extension LogUI.Target {
    
    func _log(message: Log.Message) {
        self._messages.append(message)
        let removeMessage: Log.Message?
        if self._messages.count > self.limit {
            removeMessage = self._messages.removeFirst()
        } else {
            removeMessage = nil
        }
        DispatchQueue.main.async(execute: {[weak self] in
            guard let self = self else { return }
            self._didLog(append: message, remove: removeMessage)
        })
    }
    
    func _didLog(append: Log.Message, remove: Log.Message?) {
        self._observer.notify({ $0.append(self, message: append) })
        if let remove = remove {
            self._observer.notify({ $0.remove(self, message: remove) })
        }
    }
    
}
