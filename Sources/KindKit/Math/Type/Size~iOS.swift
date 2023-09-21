//
//  KindKit
//

#if os(iOS)

import UIKit

public extension Size {
    
    @inlinable
    func inset(_ value: UIEdgeInsets) -> Self {
        return self.inset(Inset(value))
    }
    
}

#endif
