//
//  KindKit
//

import Foundation

public extension Log.Target {
    
    final class OS {
        
        public init() {
        }
        
    }
    
}

extension Log.Target.OS : ILogTarget {
    
    public var files: [URL] {
        return []
    }
    
    public func log(level: Log.Level, category: String, message: String) {
        NSLog("[\(category)]: \(message)")
    }
    
}
