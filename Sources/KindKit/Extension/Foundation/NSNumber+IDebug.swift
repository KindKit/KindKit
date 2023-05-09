//
//  KindKit
//

import Foundation

extension NSNumber : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .string("\(self.description)")
    }
    
}
