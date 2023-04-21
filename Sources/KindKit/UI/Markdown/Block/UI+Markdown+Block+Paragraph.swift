//
//  KindKit
//

import Foundation

public extension UI.Markdown.Block {
    
    struct Paragraph : Equatable {
        
        public let content: UI.Markdown.Text
        
        public init(
            content: UI.Markdown.Text
        ) {
            self.content = content
        }
        
    }
    
}
