//
//  KindKit
//

import Foundation

extension NSData : IEntity {
    
    public func debugInfo() -> Info {
        return (self as Data).debugInfo()
    }

}
