//
//  KindKitModule
//

import Foundation

public protocol IModuleManager {
    
    var modules: [IModule] { get }
    
}

public extension IModuleManager {
    
    func callToAction() -> IModuleCallToAction? {
        for module in self.modules {
            if let callToAction = module.activeCallToAction {
                return callToAction
            }
        }
        return nil
    }
    
    func showCallToActionIfNeeded() {
        guard let callToAction = self.callToAction() else { return }
        callToAction.show()
    }
    
}
