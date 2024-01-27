//
//  KindKit
//

import Foundation
import KindGeometry

public extension Size {
    
    @inlinable
    func size(
        string: String,
        font: Font,
        numberOfLines: UInt
    ) -> Self {
        return self.size(
            string: string.kk_attributed(font: font),
            numberOfLines: numberOfLines
        )
    }
    
    @inlinable
    func size(
        string: NSAttributedString,
        numberOfLines: UInt
    ) -> Self {
        let size = string.kk_size(
            numberOfLines: numberOfLines,
            available: self.cgSize
        )
        return .init(size)
    }
    
}
