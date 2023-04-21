//
//  KindKit
//

import Foundation

public extension UI.Markdown.Text.Part {
    
    struct Link : Equatable {
        
        public let text: UI.Markdown.Text
        public let url: URL?
        
        public init(
            text: UI.Markdown.Text,
            url: URL?
        ) {
            self.text = text
            self.url = url
        }
        
    }
    
}

public extension UI.Markdown.Text.Part.Link {
    
    @inlinable
    func attributedString(
        style: UI.Markdown.Style.Text,
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
        style: UI.Markdown.Style.Text.Specific,
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
