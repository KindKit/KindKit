//
//  KindKit
//

import Foundation

public struct Font : Equatable {
    
    public var native: NativeFont
    
    public init(
        _ native: NativeFont
    ) {
        self.native = native
    }
    
}
