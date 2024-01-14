//
//  KindKit
//

import Foundation

public extension Target {
    
    final class Default {
        
        public init() {
        }
        
    }
    
}

extension Target.Default : ITarget {
    
    public var files: [URL] {
        return []
    }
    
    public func log(message: IMessage) {
        print("[\(message.category)]: \(message.string(options: .pretty))")
    }
    
}
