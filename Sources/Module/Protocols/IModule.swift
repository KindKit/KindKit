//
//  KindKitModule
//

import Foundation
import KindKitCore

public protocol IModule : AnyObject {
    
    var features: [IModuleFeature] { get }
    var callToActions: [IModuleCallToAction] { get }
    
}

public extension IModule {
    
    var activeCallToAction: IModuleCallToAction? {
        return self._callToAction(self.callToActions)
    }
    
    func showCallToActionIfNeeded() {
        guard let callToAction = self.activeCallToAction else { return }
        callToAction.show()
    }
    
}

private extension IModule {
    
    @inline(__always)
    func _callToAction(_ list: [IModuleCallToAction]) -> IModuleCallToAction? {
        for element in list {
            let dependency = self._callToAction(element.dependencies)
            if element.canShow == true {
                return dependency ?? element
            } else if let dependency = dependency {
                return dependency
            }
        }
        return nil
    }
    
}
