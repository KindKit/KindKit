//
//  KindKit
//

import Foundation

extension NSURL : DebugTrait {
    
    public func buildInfo() -> Info {
        return (self as URL).buildInfo()
    }

}
