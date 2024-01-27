//
//  KindKit
//

import Foundation

public struct PlainMessage : Message {
    
    public let id: String
    public let date: Date
    public let level: Level
    public let category: String
    public let string: String
    
    public init(
        level: Level,
        category: String,
        string: String
    ) {
        self.id = UUID().uuidString
        self.date = Date()
        self.level = level
        self.category = category
        self.string = string
    }
    
    public init< TargetType : AnyObject >(
        level: Level,
        object: TargetType.Type,
        message: String
    ) {
        self.init(
            level: level,
            category: String(describing: object),
            string: message
        )
    }
    
    public init< TargetType : AnyObject >(
        level: Level,
        object: TargetType,
        message: String
    ) {
        self.init(
            level: level,
            category: String(describing: type(of: object)),
            string: message
        )
    }
    
    public func string(options: Options) -> String {
        return self.string
    }
    
}

extension PlainMessage : Hashable {
}

extension PlainMessage : Equatable {
}

extension PlainMessage : Sendable {
}
