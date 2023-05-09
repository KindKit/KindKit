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
    
    public func log(message: ILogMessage) {
        print("[\(message.category)]: \(message.string(options: .pretty))")
    }
    
}
