//
//  KindKit
//

import Foundation

extension NSString : IEntity {
    
    public func debugInfo() -> Info {
        return (self as String).debugInfo()
    }

}
