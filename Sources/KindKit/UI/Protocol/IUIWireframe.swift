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
    
#endif
    
    @discardableResult
    func close(animated: Bool = true, completion: (() -> Void)? = nil) -> Bool {
        return self.container.close(animated: animated, completion: completion)
    }
    
}
