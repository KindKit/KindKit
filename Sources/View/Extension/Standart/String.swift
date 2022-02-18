//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension String {
    
    @inlinable
    func size(font: Font, available: SizeFloat) -> SizeFloat {
        let attributed = NSAttributedString(string: self, attributes: [ .font : font.native ])
        return attributed.size(available: available)
    }
    
}
