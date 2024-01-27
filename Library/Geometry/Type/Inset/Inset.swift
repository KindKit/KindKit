//
//  KindKit
//

import KindNumeric

public struct Inset : Hashable, Equatable {
    
    public var top: Coordinate
    public var left: Coordinate
    public var right: Coordinate
    public var bottom: Coordinate
    
    public init(top: Coordinate, left: Coordinate, right: Coordinate, bottom: Coordinate) {
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }
    
    public init(horizontal: Coordinate, vertical: Coordinate) {
        self.top = vertical
        self.left = horizontal
        self.right = horizontal
        self.bottom = vertical
    }
    
    public init(all: Coordinate) {
        self.top = all
        self.left = all
        self.right = all
        self.bottom = all
    }
    
}

public extension Inset {
    
    @inlinable
    var horizontal: Coordinate {
        return self.left + self.right
    }
    
    @inlinable
    var vertical: Coordinate {
        return self.top + self.bottom
    }
    
    @inlinable
    func trim(
        top: Bool = false,
        left: Bool = false,
        right: Bool = false,
        bottom: Bool = false
    ) -> Self {
        return .init(
            top: top == true ? .zero : self.top,
            left: left == true ? .zero : self.left,
            right: right == true ? .zero : self.right,
            bottom: bottom == true ? .zero : self.bottom
        )
    }
    
}
