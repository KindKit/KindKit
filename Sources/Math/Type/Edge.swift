//
//  KindKit
//

import Foundation
import CoreGraphics

public struct Edge : Hashable {
    
    public var start: CornerIndex
    public var end: CornerIndex
    
    public init(
        start: CornerIndex,
        end: CornerIndex
    ) {
        self.start = start
        self.end = end
    }
    
    public init(
        start: Int,
        end: Int
    ) {
        self.start = CornerIndex(start)
        self.end = CornerIndex(end)
    }
    
}

public extension Edge {
    
    @inlinable
    var inverse: Self {
        return Edge(start: self.end, end: self.start)
    }

}
