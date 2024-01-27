//
//  KindKit
//

extension Text {
    
    public struct Range : Equatable, Hashable {
        
        public let lower: Index
        public let upper: Index
        
        public init(
            lower: Index,
            upper: Index
        ) {
            self.lower = lower
            self.upper = upper
        }
        
        public init(
            location: Index,
            count: Index
        ) {
            self.lower = location
            self.upper = location + count
        }
        
        public init(
            _ range: Swift.Range< String.Index >,
            in string: String
        ) {
            self.init(
                location: string.distance(from: string.startIndex, to: range.lowerBound),
                count: string.distance(from: range.lowerBound, to: range.upperBound)
            )
        }
        
    }
    
}

public extension Text.Range {
    
    @inlinable
    var isEmpty: Bool {
        return self.lower == self.upper
    }
    
    @inlinable
    var count: Text.Index {
        return self.upper - self.lower
    }
    
}

public extension Text.Range {
    
    @inlinable
    func `is`(contains index: Text.Index) -> Bool {
        return index >= self.lower && index < self.upper
    }
    
    @inlinable
    func `is`(contains range: Self) -> Bool {
        guard range.isEmpty == false else { return false }
        return self.is(contains: range.lower) && self.is(contains: range.upper - 1)
    }
    
    @inlinable
    func `is`(intersect range: Self) -> Bool {
        return self.lower < range.upper && range.lower < self.upper
    }
    
}
