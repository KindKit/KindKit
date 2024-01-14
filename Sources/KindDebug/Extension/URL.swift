//
//  KindKit
//

import Foundation

extension URL : IEntity {
    
    public func debugInfo() -> Info {
        return self.absoluteString.debugInfo()
    }

}
