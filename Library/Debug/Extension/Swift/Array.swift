//
//  KindKit
//

import Foundation

extension Array : DebugTrait {
    
    public func buildInfo() -> Info {
        return SequenceInfo(self.map({ element in
            if let element = element as? DebugTrait {
                return element.buildInfo()
            }
            return StringInfo(describing: element)
        }))
    }

}
