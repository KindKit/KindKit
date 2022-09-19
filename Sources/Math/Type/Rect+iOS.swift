//
//  KindKit
//

#if os(iOS)

import UIKit

public extension Rect {
    
    @inlinable
    func inset(_ value: UIEdgeInsets) -> Self {
        return self.inset(Inset(value))
    }
    
}

#endif
