//
//  KindKit
//

import Foundation

public protocol IEntity {

    func debugInfo() -> Info

}

extension CustomStringConvertible where Self : IEntity {
    
    public var description: String {
        return self.debugInfo().string()
    }
    
}

extension CustomDebugStringConvertible where Self : IEntity {
    
    public var debugDescription: String {
        return self.debugInfo().string()
    }
    
}
