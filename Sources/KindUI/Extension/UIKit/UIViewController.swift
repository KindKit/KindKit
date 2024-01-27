//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UIViewController {
    
    var kk_parent: UIViewController? {
        var responder: UIResponder? = self.next
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder!.next
        }
        return nil
    }
    
    func kk_snapshot() -> UIImage? {
        return self.view.kk_snapshot()
    }
    
}

#endif
