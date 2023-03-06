//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

public extension UI.View.Input.Text {
    
    struct ShouldReplace {
        
        public let text: String
        public let range: Range< String.Index >
        public let replacement: String
        
    }
    
}

#endif
