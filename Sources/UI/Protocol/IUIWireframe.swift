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
    
    var uiViewController: UIViewController? {
        return self.container.uiViewController
    }
    
    @discardableResult
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        return self.container.dismiss(animated: animated, completion: completion)
    }
    
#endif
    
}
