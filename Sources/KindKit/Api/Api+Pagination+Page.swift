//
//  KindKit
//

import Foundation

public extension Api.Pagination {
    
    struct Page {
        
        public let page: UInt
        public let size: UInt
        
        public init< 
            P : BinaryInteger,
            S : BinaryInteger
        >(
            page: P,
            size: S
        ) {
            self.page = UInt(page)
            self.size = UInt(size)
        }
        
        public func next() -> Self {
            return Self(page: self.page + 1, size: self.size)
        }
        
    }

}
