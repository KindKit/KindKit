//
//  KindKitView
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindKitCore

public protocol IWireframe {
    
    associatedtype Container : IContainer
    
    var container: Container { get }
    
}

public extension IWireframe {
    
    #if os(iOS)
    
    var viewController: UIViewController? {
        return self.container.viewController
    }
    
    #endif
    
}
