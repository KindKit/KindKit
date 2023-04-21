//
//  KindKit
//

import Foundation

public extension UI.Markdown.StyleSheet.Simple {
    
    struct Paragraph {
        
        public let style: UI.Markdown.Style.Block.Paragraph
        public let content: UI.Markdown.Style.Text
        
        public init(
            style: UI.Markdown.Style.Block.Paragraph,
            content: UI.Markdown.Style.Text
        ) {
            self.style = style
            self.content = content
        }
        
    }
    
}
