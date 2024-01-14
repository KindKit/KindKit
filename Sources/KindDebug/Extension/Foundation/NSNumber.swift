//
//  KindKit
//

import Foundation

extension NSNumber : IEntity {
    
    public func debugInfo() -> Info {
        return .string("\(self.description)")
    }
    
}
