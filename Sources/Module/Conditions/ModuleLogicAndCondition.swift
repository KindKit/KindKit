//
//  KindKitModule
//

import Foundation
import KindKitCore

public final class ModuleLogicAndCondition : IModuleCondition {
    
    public var state: Bool {
        guard self._conditions.isEmpty == false else {
            return false
        }
        for condition in self._conditions {
            if condition.state == false {
                return false
            }
        }
        return true
    }
    
    private var _conditions: [IModuleCondition]
    
    public init(_ conditions: [IModuleCondition]) {
        self._conditions = conditions
    }
    
}
