//
//  KindKit
//

import Foundation

public extension Log.Target {
    
    final class Default {
        
        public init() {
        }
        
    }
    
}

extension Log.Target.Default : ILogTarget {
    
    public var files: [URL] {
        return []
    }
    
    public func log(level: Log.Level, category: String, message: String) {
        print("[\(category)]: \(message)")
    }
    
}
