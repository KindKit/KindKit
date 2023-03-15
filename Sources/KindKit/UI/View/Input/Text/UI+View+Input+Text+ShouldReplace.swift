//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

public extension UI.View.Input.Text {
    
    struct ShouldReplace {
        
        public let text: Swift.String
        public let range: Range< Swift.String.Index >
        public let replacement: Swift.String
        
    }
    
}

#endif
