//
//  KindKit
//

import Foundation

extension NSString : DebugTrait {
    
    public func buildInfo() -> Info {
        return (self as String).buildInfo()
    }

}
