//
//  KindKit
//

import Foundation

public extension StyleSheet.Simple {
    
    struct Paragraph {
        
        public let style: Style.Block.Paragraph
        public let content: Style.Text
        
        public init(
            style: Style.Block.Paragraph,
            content: Style.Text
        ) {
            self.style = style
            self.content = content
        }
        
    }
    
}
