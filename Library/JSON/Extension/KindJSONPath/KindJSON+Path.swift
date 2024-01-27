//
//  KindKit
//

import KindDebug
import KindJSONPath

extension Path : DebugTrait {
    
    public func buildInfo() -> Info {
        return self.string.buildInfo()
    }
    
}

extension Path : CustomStringConvertible {
}

extension Path : CustomDebugStringConvertible {
}
