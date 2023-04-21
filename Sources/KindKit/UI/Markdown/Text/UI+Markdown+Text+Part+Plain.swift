//
//  KindKit
//

import Foundation

public extension UI.Markdown.Text.Part {
    
    struct Plain : Equatable {
        
        public let options: UI.Markdown.Text.Options
        public let text: String
        
        public init(
            options: UI.Markdown.Text.Options = [],
            text: String
        ) {
            self.options = options
            self.text = text
        }
        
    }
    
}

public extension UI.Markdown.Text.Part.Plain {
    
    @inlinable
    func attributedString(
        style: UI.Markdown.Style.Text.Specific,
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
