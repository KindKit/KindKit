//
//  KindKit
//

import Foundation

public protocol IModuleManager {
    
    var modules: [IModuleInstance] { get }
    
}

public extension IModuleManager {
    
    @inlinable
    var callToAction: IModuleCallToAction? {
        for module in self.modules {
            if let callToAction = module.activeCallToAction {
                return callToAction
            }
        }
        return nil
    }
    
    @inlinable
    func showCallToActionIfNeeded() {
        self.callToAction?.show()
    }
    
}
