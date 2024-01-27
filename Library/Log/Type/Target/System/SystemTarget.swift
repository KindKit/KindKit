//
//  KindKit
//

import Foundation

public final class SystemTarget : Target {
    
    public var files: [URL] {
        return []
    }
    
    public init() {
    }
    
    public func log(message: Message) {
        NSLog("[\(message.category)]: \(message.string(options: .pretty))")
    }
    
}

extension SystemTarget : @unchecked Sendable {
}
