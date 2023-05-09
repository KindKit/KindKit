//
//  KindKit
//

import Foundation

public extension Log.Message {
    
    final class Debug : ILogMessage {
        
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
        public var level: Log.Level {
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
        private let _level: Log.Level
        private let _category: String
        private let _info: KindKit.Debug.Info
        private var _prettyString: String?
        private var _inlineString: String?
        
        public init(
            level: Log.Level,
            category: String,
            info: KindKit.Debug.Info
        ) {
            self._id = UUID().uuidString
            self._date = Date()
            self._level = level
            self._category = category
            self._info = info
        }
        
        public func string(options: Log.Message.Options) -> String {
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

public extension ILogMessage where Self == Log.Message.Debug {
    
    @inlinable
    static func debug(
        level: Log.Level,
        category: String,
        info: KindKit.Debug.Info
    ) -> Self {
        return .init(
            level: level,
            category: category,
            info: info
        )
    }
    
    @inlinable
    static func debug< Debug : IDebug >(
        level: Log.Level,
        category: String,
        info: Debug
    ) -> Self {
        return .init(
            level: level,
            category: category,
            info: info.debugInfo()
        )
    }
    
}
