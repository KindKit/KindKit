//
//  KindKit
//

import Foundation

public extension NSAttributedString {
    
    static func kk_make(_ text: Text, base: Style) -> NSAttributedString {
        let string = text.string
        let result = NSMutableAttributedString(string: string)
        text.each(base: base, { range, options in
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
