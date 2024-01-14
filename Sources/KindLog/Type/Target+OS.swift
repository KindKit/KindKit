//
//  KindKit
//

import Foundation

public extension Target {
    
    final class OS {
        
        public init() {
        }
        
    }
    
}

extension Target.OS : ITarget {
    
    public var files: [URL] {
        return []
    }
    
    public func log(message: IMessage) {
        NSLog("[\(message.category)]: \(message.string(options: .pretty))")
    }
    
}
