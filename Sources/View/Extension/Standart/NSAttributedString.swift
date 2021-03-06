//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension NSAttributedString {
    
    @inlinable
    func size(available: SizeFloat) -> SizeFloat {
        let bounding = self.boundingRect(with: available.cgSize, options: [ .usesLineFragmentOrigin, .usesFontLeading ], context: nil)
        let size = bounding.integral.size
        return SizeFloat(size)
    }
    
}

public extension NSAttributedString.Key {
    
    static let customLink = NSAttributedString.Key("Quickly::CustomLink")
    
}
