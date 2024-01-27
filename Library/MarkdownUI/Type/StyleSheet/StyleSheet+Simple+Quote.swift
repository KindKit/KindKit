//
//  KindKit
//

import Foundation

public extension StyleSheet.Simple {
    
    struct Quote {
        
        public let style: Style.Block.Quote
        public let content: Style.Text
        
        public init(
            style: Style.Block.Quote,
            content: Style.Text
        ) {
            self.style = style
            self.content = content
        }
        
    }
    
}
