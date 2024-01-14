//
//  KindKit
//

import Foundation

public extension Pagination {
    
    struct Limit {
        
        public let offset: UInt
        public let limit: UInt
        
        public init<
            L : BinaryInteger,
            O : BinaryInteger
        >(
            offset: L,
            limit: O
        ) {
            self.offset = UInt(offset)
            self.limit = UInt(limit)
        }
        
        public func next() -> Self {
            return Self(offset: self.offset + self.limit, limit: self.limit)
        }
        
    }
    
}
