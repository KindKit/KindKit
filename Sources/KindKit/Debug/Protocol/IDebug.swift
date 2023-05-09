//
//  KindKit
//

import Foundation

public protocol IDebug {

    func debugInfo() -> Debug.Info

}

extension CustomStringConvertible where Self : IDebug {
    
    public var description: String {
        return self.debugInfo().string()
    }
    
}

extension CustomDebugStringConvertible where Self : IDebug {
    
    public var debugDescription: String {
        return self.debugInfo().string()
    }
    
}
