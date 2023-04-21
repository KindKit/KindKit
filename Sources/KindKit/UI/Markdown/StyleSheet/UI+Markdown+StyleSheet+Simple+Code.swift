//
//  KindKit
//

import Foundation

public extension UI.Markdown.StyleSheet.Simple {
    
    struct Code {
        
        public let style: UI.Markdown.Style.Block.Code
        public let content: UI.Markdown.Style.Text
        
        public init(
            style: UI.Markdown.Style.Block.Code,
            content: UI.Markdown.Style.Text
        ) {
            self.style = style
            self.content = content
        }
        
    }
    
}
