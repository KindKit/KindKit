//
//  KindKit
//

import Foundation
import KindMath

public extension NSAttributedString {
    
    @inlinable
    func kk_size(numberOfLines: UInt, available: Size) -> Size {
        return .init(self.kk_size(numberOfLines: numberOfLines, available: available.cgSize))
    }
    
}
