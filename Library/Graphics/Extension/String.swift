//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindGeometry
import KindString

public extension String {
    
#if os(macOS)
    
    @inlinable
    func kk_attributed(font: NSFont) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                .font : font,
                .paragraphStyle : NSParagraphStyle.default
            ]
        )
    }
    
#elseif os(iOS)
    
    @inlinable
    func kk_attributed(font: UIFont) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [
                .font : font,
                .paragraphStyle : NSParagraphStyle.default
            ]
        )
    }
    
#endif
    
    @inlinable
    func kk_attributed(font: Font) -> NSAttributedString {
        return self.kk_attributed(font: font.native)
    }

}
