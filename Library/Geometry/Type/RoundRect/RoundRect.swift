//
//  KindKit
//

import KindNumeric

public struct RoundRect : Hashable, Equatable {
    
    public var rect: Rect
    public var corners: Corners
    
    public init(
        rect: Rect,
        corners: Corners
    ) {
        self.rect = rect
        self.corners = corners
    }
    
}
