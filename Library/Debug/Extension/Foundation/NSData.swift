//
//  KindKit
//

import Foundation

extension NSData : DebugTrait {
    
    public func buildInfo() -> Info {
        return (self as Data).buildInfo()
    }

}
