//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension NSAttributedString {
    
    @inlinable
    func kk_size(numberOfLines: UInt, available: CGSize) -> CGSize {
        let textStorage = NSTextStorage(attributedString: self)
#if os(macOS)
        let textContainer = NSTextContainer(containerSize: available)
#elseif os(iOS)
        let textContainer = NSTextContainer(size: available)
#endif
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = Int(numberOfLines)
        let layoutManager = NSLayoutManager()
        layoutManager.usesFontLeading = true
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        guard glyphRange.length > 0 else {
            return .zero
        }
        let bounding = layoutManager.usedRect(for: textContainer)
        return bounding.size
    }
    
}

public extension NSAttributedString.Key {
    
    static let kk_customLink = NSAttributedString.Key("KindCore::CustomLink")
    
}
