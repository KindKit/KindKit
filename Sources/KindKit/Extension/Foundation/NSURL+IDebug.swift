//
//  KindKit
//

import Foundation

extension NSURL : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return (self as URL).debugInfo()
    }

}
