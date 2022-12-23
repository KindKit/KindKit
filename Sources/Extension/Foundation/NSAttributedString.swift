//
//  KindKit
//

import Foundation

public extension NSAttributedString {
    
    @inlinable
    func kk_size(numberOfLines: UInt, available: Size) -> Size {
        let textStorage = NSTextStorage(attributedString: self)
#if os(macOS)
        let textContainer = NSTextContainer(containerSize: available.cgSize)
#elseif os(iOS)
        let textContainer = NSTextContainer(size: available.cgSize)
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
        return .init(bounding.size)
    }
    
}

public extension NSAttributedString.Key {
    
    static let kk_customLink = NSAttributedString.Key("KindKit::CustomLink")
    
}
