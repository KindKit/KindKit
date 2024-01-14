//
//  KindKit
//

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

extension StringInputView {
    
    public struct ShouldReplace {
        
        public let text: String
        public let range: Range< String.Index >
        public let replacement: String
        
    }
    
}

#endif
