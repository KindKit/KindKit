//
//  KindKit
//

import Foundation

extension NSData : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return (self as Data).debugInfo()
    }

}
