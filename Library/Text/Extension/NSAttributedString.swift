//
//  KindKit
//

import Foundation

public extension NSAttributedString {
    
    static func kk_make(_ text: Text) -> NSAttributedString {
        return self.kk_make(text.text, base: text.style)
    }
    
    static func kk_make(_ part: Text.Part, base: Style) -> NSAttributedString {
        let string = part.string
        let result = NSMutableAttributedString(string: string)
        part.each(base: base, { range, options in
            guard let style = options.style else { return }
            let attributes = style.attribures(flags: options.flags ?? [])
            result.addAttributes(attributes, range: .init(
                location: range.lower,
                length: range.upper - range.lower
            ))
        })
        return result
    }
    
}
