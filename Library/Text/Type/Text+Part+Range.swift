//
//  KindKit
//

extension Text.Part {
    
    public struct Range {
        
        public let lower: Text.Part.Index
        public let upper: Text.Part.Index
        
        public init(
            lower: Text.Part.Index,
            upper: Text.Part.Index
        ) {
            self.lower = lower
            self.upper = upper
        }
        
        public init(
            location: Text.Part.Index,
            count: Text.Part.Index
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

extension Text.Part.Range : Hashable {
}

extension Text.Part.Range : Equatable {
}

extension Text.Part.Range : Sendable {
}

public extension Text.Part.Range {
    
    @inlinable
    var isEmpty: Bool {
        return self.lower == self.upper
    }
    
    @inlinable
    var count: Text.Part.Index {
        return self.upper - self.lower
    }
    
}

public extension Text.Part.Range {
    
    @inlinable
    func `is`(contains index: Text.Part.Index) -> Bool {
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
