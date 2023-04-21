//
//  KindKit
//

import Foundation

public extension UI.Markdown.StyleSheet.Simple {
    
    struct List {
        
        public let style: UI.Markdown.Style.Block.List
        public let marker: UI.Markdown.Style.Text
        public let content: UI.Markdown.Style.Text
        
        public init(
            style: UI.Markdown.Style.Block.List,
            marker: UI.Markdown.Style.Text,
            content: UI.Markdown.Style.Text
        ) {
            self.style = style
            self.marker = marker
            self.content = content
        }
        
    }
    
}
