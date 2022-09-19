//
//  KindKit
//

import Foundation

public protocol IModuleInstance : AnyObject {
    
    var callToActions: [IModuleCallToAction] { get }
    
}

public extension IModuleInstance {
    
    var activeCallToAction: IModuleCallToAction? {
        return self._callToAction(self.callToActions)
    }
    
    func showCallToActionIfNeeded() {
        self.activeCallToAction?.show()
    }
    
}

private extension IModuleInstance {
    
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
