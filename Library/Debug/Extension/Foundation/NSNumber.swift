//
//  KindKit
//

import Foundation

extension NSNumber : DebugTrait {
    
    public func buildInfo() -> Info {
        return StringInfo(self.description)
    }
    
}
