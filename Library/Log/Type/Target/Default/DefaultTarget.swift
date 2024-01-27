//
//  KindKit
//

import Foundation

public final class DefaultTarget : Target {
    
    public var files: [URL] {
        return []
    }
    
    public init() {
    }
    
    public func log(message: Message) {
        print("[\(message.category)]: \(message.string(options: .pretty))")
    }
    
}

extension DefaultTarget : @unchecked Sendable {
}
