//
//  KindKit
//

import KindEvent
import KindLog

protocol ILogUITargetObserver : AnyObject {
    
    func append(_ target: LogUI.Target, message: IMessage)
    func remove(_ target: LogUI.Target, message: IMessage)

}

public extension LogUI {

    final class Target {
        
        public let limit: Int
        var messages: [IMessage] {
            return self._queue.sync(flags: .barrier, execute: {
                return self._messages
            })
        }

        private var _messages: [IMessage] = []
        private let _queue = DispatchQueue(label: "KindKit.LogTarget")
        private let _observer = Observer< ILogUITargetObserver >()
        
        public init(
            limit: Int = 512
        ) {
            self.limit = limit
        }

    }

}

extension LogUI.Target {
    
    func add(observer: ILogUITargetObserver, priority: KindEvent.Priority) {
        self._observer.add(observer, priority: priority)
    }
    
    func remove(observer: ILogUITargetObserver) {
        self._observer.remove(observer)
    }
    
}

extension LogUI.Target : ITarget {
    
    public var files: [URL] {
        return []
    }
    
    public func log(message: IMessage) {
        self._queue.async(execute: { [weak self] in
            guard let self = self else { return }
            self._log(message: message)
        })
        
    }
    
}

private extension LogUI.Target {
    
    func _log(message: IMessage) {
        self._messages.append(message)
        let removeMessage: IMessage?
        if self._messages.count > self.limit {
            removeMessage = self._messages.removeFirst()
        } else {
            removeMessage = nil
        }
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            self._didLog(append: message, remove: removeMessage)
        })
    }
    
    func _didLog(append: IMessage, remove: IMessage?) {
        self._observer.emit({ $0.append(self, message: append) })
        if let remove = remove {
            self._observer.emit({ $0.remove(self, message: remove) })
        }
    }
    
}
