//
//  KindKit
//

import Foundation

public extension UI.Markdown.Block {
    
    struct Code : Equatable {
        
        public let level: UInt
        public let content: UI.Markdown.Text
        
        public init(
            level: UInt,
            content: UI.Markdown.Text
        ) {
            self.level = level
            self.content = content
        }
        
    }
    
}
