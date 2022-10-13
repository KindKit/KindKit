//
//  KindKit
//

import Foundation

public extension NSAttributedString {
    
    @inlinable
    func kk_size(available: SizeFloat) -> SizeFloat {
        let bounding = self.boundingRect(with: available.cgSize, options: [ .usesLineFragmentOrigin, .usesFontLeading ], context: nil)
        let size = bounding.integral.size
        return Size(size)
    }
    
}

public extension NSAttributedString.Key {
    
    static let kk_customLink = NSAttributedString.Key("KindKit::CustomLink")
    
}
