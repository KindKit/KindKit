//
//  KindKit
//

import Foundation
import KindMath

public extension String {
    
    @inlinable
    func kk_attributed(font: Font) -> NSAttributedString {
        return self.kk_attributed(font: font.native)
    }
    
    @inlinable
    func kk_size(font: Font, numberOfLines: UInt, available: Size) -> Size {
        let attributed = self.kk_attributed(font: font)
        return attributed.kk_size(numberOfLines: numberOfLines, available: available)
    }

}
