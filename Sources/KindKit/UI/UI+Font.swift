//
//  KindKit
//

import Foundation

public extension UI {
    
    struct Font : Equatable {

        public var native: NativeFont
        
        public init(
            _ native: NativeFont
        ) {
            self.native = native
        }
        
    }
    
}
