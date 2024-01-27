//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindMath
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
    
    @inlinable
    func kk_size(font: NSFont, numberOfLines: UInt, available: CGSize) -> CGSize {
        let attributed = self.kk_attributed(font: font)
        return attributed.kk_size(numberOfLines: numberOfLines, available: available)
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
    
    @inlinable
    func kk_size(font: UIFont, numberOfLines: UInt, available: CGSize) -> CGSize {
        let attributed = self.kk_attributed(font: font)
        return attributed.kk_size(numberOfLines: numberOfLines, available: available)
    }
    
#endif
    
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
