//
//  KindKit
//

import KindNumeric

public struct Anchor2 : Hashable, Equatable {
    
    public var x: Percent
    public var y: Percent
    
    public init(x: Percent, y: Percent) {
        self.x = x
        self.y = y
    }
    
    public init(both: Percent) {
        self.x = both
        self.y = both
    }
    
    public init(point: Point, size: Size) {
        self.x = .init(point.x, from: size.width)
        self.y = .init(point.y, from: size.height)
    }
    
}
