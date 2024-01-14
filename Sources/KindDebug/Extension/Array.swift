//
//  KindKit
//

import Foundation

extension Array : IEntity {
    
    public func debugInfo() -> Info {
        return .sequence(self.map({ .cast($0) }))
    }

}
