//
//  KindKit
//

import KindCore

extension AlignedBox2.CenteredForm : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.center)
        hasher.combine(self.extent)
    }
    
}

extension AlignedBox2.CenteredForm  : Equatable {
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.center == rhs.center && lhs.extent == rhs.extent
    }
    
}

extension AlignedBox2.CenteredForm  : Comparable {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.center < rhs.center && lhs.extent < rhs.extent
    }
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.center > rhs.center && lhs.extent > rhs.extent
    }
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.center <= rhs.center && lhs.extent <= rhs.extent
    }
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.center >= rhs.center && lhs.extent >= rhs.extent
    }
    
}
