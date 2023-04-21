//
//  KindKit
//

import Foundation

public extension UI.Markdown.Block {
    
    struct List : Equatable {
        
        public let marker: UI.Markdown.Text
        public let content: UI.Markdown.Text
        
        public init(
            marker: UI.Markdown.Text,
            content: UI.Markdown.Text
        ) {
            self.marker = marker
            self.content = content
        }
        
    }
    
}
