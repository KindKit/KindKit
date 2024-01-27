//
//  KindKit
//

import KindNumeric

extension Polyline2 {
    
    public struct Edge {
        
        public let start: CornerIndex
        public let end: CornerIndex
        
        public init(start: CornerIndex, end: CornerIndex) {
            self.start = start
            self.end = end
        }
        
        public init< Start : BinaryInteger, End : BinaryInteger >(start: Start, end: End) {
            self.start = .init(start)
            self.end = .init(end)
        }
        
    }
    
}

extension Polyline2.Edge : InvertTrait {
    
    @inlinable
    public var invert: Self {
        return .init(start: self.end, end: self.start)
    }

}
