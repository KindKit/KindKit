//
//  KindKit
//

import Foundation

public extension StyleSheet.Simple {
    
    struct Heading {
        
        public let style: Style.Block.Heading
        public let content: Style.Text
        
        public init(
            style: Style.Block.Heading,
            content: Style.Text
        ) {
            self.style = style
            self.content = content
        }
        
    }
    
}
