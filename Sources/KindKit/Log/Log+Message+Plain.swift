//
//  KindKit
//

import Foundation

public extension Log.Message {
    
    final class Plain : ILogMessage {
        
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
        private let _string: String
        
        public init(
            level: Log.Level,
            category: String,
            string: String
        ) {
            self._id = UUID().uuidString
            self._date = Date()
            self._level = level
            self._category = category
            self._string = string
        }
        
        public func string(options: Log.Message.Options) -> String {
            return self._lock.perform({
                return self._string
            })
        }
        
    }
    
}

public extension ILogMessage where Self == Log.Message.Plain {
    
    @inlinable
    static func plain(
        level: Log.Level,
        category: String,
        string: String
    ) -> Self {
        return .init(
            level: level,
            category: category,
            string: string
        )
    }
    
}
