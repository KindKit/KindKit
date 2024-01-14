//
//  KindKit
//

import KindMarkdown

public extension KindMarkdown.Text.Part.Link {
    
    @inlinable
    func attributedString(
        style: Style.Text,
        extra: [NSAttributedString.Key : Any]
    ) -> NSAttributedString {
        var extra = extra
        if let url = self.url {
            extra[.kk_customLink] = url
        }
        return self.text.attributedString(
            style: style,
            extra: extra
        )
    }
    
    @inlinable
    func attributedString(
        style: Style.Text.Specific,
        extra: [NSAttributedString.Key : Any]
    ) -> NSAttributedString {
        var extra = extra
        if let url = self.url {
            extra[.kk_customLink] = url
        }
        return self.text.attributedString(
            style: style,
            extra: extra
        )
    }
    
}
