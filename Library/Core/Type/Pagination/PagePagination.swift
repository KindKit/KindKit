//
//  KindKit
//

public struct PagePagination : Pagination {
    
    public let page: UInt
    public let size: UInt
    
    public init<
        Page : BinaryInteger,
        Size : BinaryInteger
    >(
        page: Page,
        size: Size
    ) {
        self.page = UInt(page)
        self.size = UInt(size)
    }
    
    public func next() -> Self {
        return .init(
            page: self.page + 1,
            size: self.size
        )
    }
    
    }
