//
//  KindKit
//

import KindMarkdown

public extension KindMarkdown.Text {
    
    @inlinable
    func attributedString(
        style: Style.Text,
        extra: [NSAttributedString.Key : Any] = [:]
    ) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.beginEditing()
        for part in self.parts {
            result.append(part.attributedString(style: style, extra: extra))
        }
        result.endEditing()
        return result
    }
    
    @inlinable
    func attributedString(
        style: Style.Text.Specific,
        extra: [NSAttributedString.Key : Any] = [:]
    ) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.beginEditing()
        for part in self.parts {
            result.append(part.attributedString(style: style, extra: extra))
        }
        result.endEditing()
        return result
    }
    
}
