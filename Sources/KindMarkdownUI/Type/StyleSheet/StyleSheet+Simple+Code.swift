//
//  KindKit
//

import Foundation

public extension StyleSheet.Simple {
    
    struct Code {
        
        public let style: Style.Block.Code
        public let content: Style.Text
        
        public init(
            style: Style.Block.Code,
            content: Style.Text
        ) {
            self.style = style
            self.content = content
        }
        
    }
    
}
