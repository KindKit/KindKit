//
//  KindKit
//

import Foundation

public extension Log {
    
    struct Message : Equatable {
        
        public let date: Date
        public let level: Log.Level
        public let category: String
        public let message: String
        
        public init(
            level: Log.Level,
            category: String,
            message: String
        ) {
            self.date = Date()
            self.level = level
            self.category = category
            self.message = message
        }
        
        public init<
            Message : IDebug
        >(
            level: Log.Level,
            category: String,
            message: Message
        ) {
            self.init(
                level: level,
                category: category,
                message: message.dump()
            )
        }
        
    }
    
}
