//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

public protocol IUIWireframe {
    
    associatedtype Container : IUIContainer
    
    var container: Container { get }
    
}

public extension IUIWireframe {
    
    #if os(iOS)
    
    var viewController: UIViewController? {
        return self.container.viewController
    }
    
    #endif
    
}
