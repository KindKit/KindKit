//
//  KindKit
//

import Foundation

extension URL : DebugTrait {
    
    public func buildInfo() -> Info {
        return self.absoluteString.buildInfo()
    }

}
