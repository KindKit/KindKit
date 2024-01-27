//
//  KindKit
//

import Foundation

public struct Font {
    
    public var native: HandleFont
    
    public init(
        _ native: HandleFont
    ) {
        self.native = native
    }
    
}

extension Font : Hashable {
}

extension Font : Equatable {
}

extension Font : @unchecked Sendable {
}
