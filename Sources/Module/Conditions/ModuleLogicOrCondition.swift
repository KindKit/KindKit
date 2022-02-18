//
//  KindKitModule
//

import Foundation
import KindKitCore

public class ModuleLogicOrCondition : IModuleCondition {
    
    public var state: Bool {
        for condition in self._conditions {
            if condition.state == true {
                return true
            }
        }
        return false
    }
    
    private var _conditions: [IModuleCondition]
    
    public init(_ conditions: [IModuleCondition]) {
        self._conditions = conditions
    }
    
}
