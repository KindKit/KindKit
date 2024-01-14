//
//  KindKit
//

import Foundation

extension NSArray : IEntity {
    
    public func debugInfo() -> Info {
        return .sequence(self.map({ .cast($0) }))
    }

}
