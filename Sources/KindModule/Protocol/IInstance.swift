//
//  KindKit
//

import Foundation

public protocol IInstance : AnyObject {
    
    var callToActions: [ICallToAction] { get }
    
}

public extension IInstance {
    
    var activeCallToAction: ICallToAction? {
        return self._callToAction(self.callToActions)
    }
    
    func showCallToActionIfNeeded() {
        self.activeCallToAction?.show()
    }
    
}

private extension IInstance {
    
    @inline(__always)
    func _callToAction(_ list: [ICallToAction]) -> ICallToAction? {
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
