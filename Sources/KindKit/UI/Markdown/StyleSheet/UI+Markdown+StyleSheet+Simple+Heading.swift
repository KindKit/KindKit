//
//  KindKit
//

import Foundation

public extension UI.Markdown.StyleSheet.Simple {
    
    struct Heading {
        
        public let style: UI.Markdown.Style.Block.Heading
        public let content: UI.Markdown.Style.Text
        
        public init(
            style: UI.Markdown.Style.Block.Heading,
            content: UI.Markdown.Style.Text
        ) {
            self.style = style
            self.content = content
        }
        
    }
    
}
