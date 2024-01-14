//
//  KindKit
//

import Foundation

extension NSURL : IEntity {
    
    public func debugInfo() -> Info {
        return (self as URL).debugInfo()
    }

}
