//
//  KindKit
//

public struct LimitPagination : Pagination {
    
    public let offset: UInt
    public let limit: UInt
    
    public init<
        Offset : BinaryInteger,
        Limit : BinaryInteger
    >(
        offset: Offset,
        limit: Limit
    ) {
        self.offset = UInt(offset)
        self.limit = UInt(limit)
    }
    
    public func next() -> Self {
        return .init(
            offset: self.offset + self.limit,
            limit: self.limit
        )
    }
    
}
