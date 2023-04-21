//
//  KindKit
//

import Foundation

public extension UI.Markdown.StyleSheet.Simple {
    
    struct Quote {
        
        public let style: UI.Markdown.Style.Block.Quote
        public let content: UI.Markdown.Style.Text
        
        public init(
            style: UI.Markdown.Style.Block.Quote,
            content: UI.Markdown.Style.Text
        ) {
            self.style = style
            self.content = content
        }
        
    }
    
}
