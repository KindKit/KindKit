//
//  KindKit
//

import Foundation

extension Polyline2 {
    
    public struct Edge : Hashable {
        
        public let start: CornerIndex
        public let end: CornerIndex
        
        public init(start: CornerIndex, end: CornerIndex) {
            self.start = start
            self.end = end
        }
        
        public init(start: Int, end: Int) {
            self.start = .init(start)
            self.end = .init(end)
        }
        
    }
    
}

public extension Polyline2.Edge {
    
    @inlinable
    var inverse: Self {
        return .init(start: self.end, end: self.start)
    }

}
