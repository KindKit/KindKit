//
//  KindKit
//

import KindMarkdown

public extension KindMarkdown.Text.Part {
    
    @inlinable
    func attributedString(
        style: Style.Text,
        extra: [NSAttributedString.Key : Any]
    ) -> NSAttributedString {
        switch self {
        case .plain(let part): return part.attributedString(style: style.normal, extra: extra)
        case .link(let part): return part.attributedString(style: style.link, extra: extra)
        }
    }
    
    @inlinable
    func attributedString(
        style: Style.Text.Specific,
        extra: [NSAttributedString.Key : Any]
    ) -> NSAttributedString {
        switch self {
        case .plain(let part): return part.attributedString(style: style, extra: extra)
        case .link(let part): return part.attributedString(style: style, extra: extra)
        }
    }
    
}
