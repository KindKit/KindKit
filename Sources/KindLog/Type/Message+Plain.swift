//
//  KindKit
//

import Foundation

public extension Message {
    
    final class Plain : IMessage {
        
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
        private let _string: String
        
        public init(
            level: Level,
            category: String,
            string: String
        ) {
            self._id = UUID().uuidString
            self._date = Date()
            self._level = level
            self._category = category
            self._string = string
        }
        
        public convenience init< TargetTypeType : AnyObject >(
            level: Level,
            object: TargetTypeType.Type,
            message: String
        ) {
            self.init(
                level: level,
                category: String(describing: object),
                string: message
            )
        }
        
        public convenience init< TargetTypeType : AnyObject >(
            level: Level,
            object: TargetTypeType,
            message: String
        ) {
            self.init(
                level: level,
                category: String(describing: type(of: object)),
                string: message
            )
        }
        
        public func string(options: Message.Options) -> String {
            return self._lock.perform({
                return self._string
            })
        }
        
    }
    
}

public extension Manager {
    
    @inlinable
    func log(plain: Message.Plain) {
        self.log(message: plain)
    }
    
}
