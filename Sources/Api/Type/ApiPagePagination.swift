//
//  KindKitApi
//

import Foundation

public struct ApiPagePagination {
    
    public let page: UInt
    public let size: UInt
    
    public init(
        page: UInt,
        size: UInt
    ) {
        self.page = page
        self.size = size
    }
    
    public func next() -> Self {
        return Self(page: self.page + 1, size: self.size)
    }
    
}
