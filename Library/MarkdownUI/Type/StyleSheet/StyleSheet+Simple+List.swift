//
//  KindKit
//

import Foundation

public extension StyleSheet.Simple {
    
    struct List {
        
        public let style: Style.Block.List
        public let marker: Style.Text
        public let content: Style.Text
        
        public init(
            style: Style.Block.List,
            marker: Style.Text,
            content: Style.Text
        ) {
            self.style = style
            self.marker = marker
            self.content = content
        }
        
    }
    
}
