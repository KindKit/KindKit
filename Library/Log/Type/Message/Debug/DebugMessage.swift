//
//  KindKit
//

import Foundation
import KindDebug

public struct DebugMessage : Message {
    
    public let id: String
    public let date: Date
    public let level: Level
    public let category: String
    public let info: any Info
    
    public init(
        level: Level,
        category: String,
        info: any Info
    ) {
        self.id = UUID().uuidString
        self.date = Date()
        self.level = level
        self.category = category
        self.info = info
    }
    
    public init< Debug : KindDebug.DebugTrait >(
        level: Level,
        category: String,
        info: Debug
    ) {
        self.init(
            level: level,
            category: category,
            info: info.buildInfo()
        )
    }
    
    public func string(options: Options) -> String {
        if options.contains(.pretty) == false {
            return self.info.string(options: .inline)
        } else {
            return self.info.string()
        }
    }
    
}

extension DebugMessage : Sendable {
}
