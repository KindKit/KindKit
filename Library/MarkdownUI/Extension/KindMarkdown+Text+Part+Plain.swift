//
//  KindKit
//

import KindMarkdown

public extension KindMarkdown.Text.Part.Plain {
    
    @inlinable
    func attributedString(
        style: Style.Text.Specific,
        extra: [NSAttributedString.Key : Any]
    ) -> NSAttributedString {
        var attribures = style.attribures(options: self.options)
        for extra in extra {
            attribures[extra.key] = extra.value
        }
        return NSAttributedString(
            string: self.text,
            attributes: attribures
        )
    }
    
}
