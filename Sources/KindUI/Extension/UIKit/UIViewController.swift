//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UIViewController {
    
    func kk_snapshot() -> UIImage? {
        return self.view.kk_snapshot()
    }
    
}

#endif
