//
//  KindKit
//

import KindDebug

public extension Message {
    
    final class Debug : IMessage {
        
        public var id: String {
            return self._lock.perform({
                return self._id
            })
        }
        public var date: Date {
            return self._lock.perform({
                return self._date
            })
        }
        public var level: Level {
            return self._lock.perform({
                return self._level
            })
        }
        public var category: String {
            return self._lock.perform({
                return self._category
            })
        }
        
        private let _lock = Lock()
        private let _id: String
        private let _date: Date
        private let _level: Level
        private let _category: String
        private let _info: KindDebug.Info
        private var _prettyString: String?
        private var _inlineString: String?
        
        public init(
            level: Level,
            category: String,
            info: KindDebug.Info
        ) {
            self._id = UUID().uuidString
            self._date = Date()
            self._level = level
            self._category = category
            self._info = info
        }
        
        public convenience init< DebugType : KindDebug.IEntity >(
            level: Level,
            category: String,
            info: DebugType
        ) {
            self.init(
                level: level,
                category: category,
                info: info.debugInfo()
            )
        }
        
        public func string(options: Message.Options) -> String {
            return self._lock.perform({
                let string: String
                if options.contains(.pretty) == false {
                    if let cache = self._inlineString {
                        string = cache
                    } else {
                        string = self._info.string(options: .inline)
                        self._inlineString = string
                    }
                } else {
                    if let cache = self._prettyString {
                        string = cache
                    } else {
                        string = self._info.string()
                        self._prettyString = string
                    }
                }
                return string
            })
        }
        
    }
    
}

public extension Manager {
    
    @inlinable
    func log(debug: Message.Debug) {
        self.log(message: debug)
    }
    
}
