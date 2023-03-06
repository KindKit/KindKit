//
//  KindKit
//

import Foundation

extension Observer {
    
    final class Item {
        
        var priority: UInt
        weak var object: AnyObject?
        
        init(priority: UInt, observer: Target) {
            self.priority = priority
            self.object = observer as AnyObject
        }
        
        func contains(observer: Target) -> Bool {
            guard let object = self.object else {
                return false
            }
            return object === (observer as AnyObject)
        }
        
        func get() -> Target? {
            guard let object = self.object else { return nil }
            return object as? Target
        }

    }
    
}
