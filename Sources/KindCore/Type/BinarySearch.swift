//
//  KindKit
//

public enum BinarySearch {
}
    
public extension BinarySearch {
    
    @inlinable
    static func any< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        of element: CollectionType.Element
    ) -> CollectionType.Index? where CollectionType.Element : Comparable {
        return Self.any(collection, range: collection.startIndex ..< collection.endIndex, of: element)
    }
    
    @inlinable
    static func any< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        of element: CollectionType.Element
    ) -> CollectionType.Index? where CollectionType.Element : Comparable {
        return Self.any(collection, range: range, predicate: {
            if $0 < element {
                return .less
            } else if $0 > element {
                return .more
            }
            return .same
        })
    }
    
    @inlinable
    static func any< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        predicate: (CollectionType.Element) -> Predicate
    ) -> CollectionType.Index? {
        return Self.any(collection, range: collection.startIndex ..< collection.endIndex, predicate: predicate)
    }
    
    static func any< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        predicate: (CollectionType.Element) -> Predicate
    ) -> CollectionType.Index? {
        var lower = range.lowerBound
        var upper = range.upperBound
        while lower < upper {
            let distance = collection.distance(from: lower, to: upper)
            let index = collection.index(lower, offsetBy: distance / 2)
            switch predicate(collection[index]) {
            case .less:
                lower = collection.index(after: index)
            case .same:
                return index
            case .more:
                upper = index
            }
        }
        return nil
    }
    
}
    
public extension BinarySearch {
    
    @inlinable
    static func first< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        of element: CollectionType.Element
    ) -> CollectionType.Index? where CollectionType.Element : Comparable {
        return Self.first(collection, range: collection.startIndex ..< collection.endIndex, of: element)
    }
    
    @inlinable
    static func first< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        of element: CollectionType.Element
    ) -> CollectionType.Index? where CollectionType.Element : Comparable {
        return Self.first(collection, range: range, predicate: {
            if $0 < element {
                return .less
            } else if $0 > element {
                return .more
            }
            return .same
        })
    }
    
    @inlinable
    static func first< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        predicate: (CollectionType.Element) -> Predicate
    ) -> CollectionType.Index? {
        return Self.first(collection, range: collection.startIndex ..< collection.endIndex, predicate: predicate)
    }
    
    static func first< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        predicate: (CollectionType.Element) -> Predicate
    ) -> CollectionType.Index? {
        var result: CollectionType.Index? = nil
        var lower = range.lowerBound
        var upper = range.upperBound
        while lower < upper {
            let distance = collection.distance(from: lower, to: upper)
            let index = collection.index(lower, offsetBy: distance / 2)
            switch predicate(collection[index]) {
            case .less:
                lower = collection.index(after: index)
            case .same:
                result = index
                upper = index
            case .more:
                upper = index
            }
        }
        return result
    }
    
}
    
public extension BinarySearch {
    
    @inlinable
    static func last< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        of element: CollectionType.Element
    ) -> CollectionType.Index? where CollectionType.Element : Comparable {
        return Self.last(collection, range: collection.startIndex ..< collection.endIndex, of: element)
    }
    
    @inlinable
    static func last< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        of element: CollectionType.Element
    ) -> CollectionType.Index? where CollectionType.Element : Comparable {
        return Self.last(collection, range: range, predicate: {
            if $0 < element {
                return .less
            } else if $0 > element {
                return .more
            }
            return .same
        })
    }
    
    @inlinable
    static func last< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        predicate: (CollectionType.Element) -> Predicate
    ) -> CollectionType.Index? {
        return Self.last(collection, range: collection.startIndex ..< collection.endIndex, predicate: predicate)
    }
    
    static func last< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        predicate: (CollectionType.Element) -> Predicate
    ) -> CollectionType.Index? {
        var result: CollectionType.Index? = nil
        var lower = range.lowerBound
        var upper = range.upperBound
        while lower < upper {
            let distance = collection.distance(from: lower, to: upper)
            let index = collection.index(lower, offsetBy: distance / 2)
            switch predicate(collection[index]) {
            case .less:
                lower = collection.index(after: index)
            case .same:
                result = index
                lower = collection.index(after: index)
            case .more:
                upper = index
            }
        }
        return result
    }
    
}
    
public extension BinarySearch {
    
    @inlinable
    static func range< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        of element: Range< CollectionType.Element >
    ) -> Range< CollectionType.Index >? where CollectionType.Element : Comparable {
        return Self.range(collection, range: collection.startIndex ..< collection.endIndex, of: element)
    }
    
    @inlinable
    static func range< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        of element: Range< CollectionType.Element >
    ) -> Range< CollectionType.Index >? where CollectionType.Element : Comparable {
        return Self.range(collection, range: range, predicate: {
            if $0 < element.lowerBound {
                return .less
            } else if $0 > element.upperBound {
                return .more
            }
            return .same
        })
    }
    
    @inlinable
    static func range< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        predicate: (CollectionType.Element) -> Predicate
    ) -> Range< CollectionType.Index >? {
        return Self.range(collection, range: collection.startIndex ..< collection.endIndex, predicate: predicate)
    }
    
    static func range< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        predicate: (CollectionType.Element) -> Predicate
    ) -> Range< CollectionType.Index >? {
        guard collection.count >= 2 else {
            return self._each(collection, range: range, predicate: predicate)
        }
        switch (predicate(collection[range.lowerBound]), predicate(collection[collection.index(before: range.upperBound)])) {
        case (.same, .same):
            return range.lowerBound ..< range.upperBound
        case (.same, .more):
            let anchor = collection.index(after: range.lowerBound)
            if let new = Self.last(collection, range: anchor ..< range.upperBound, predicate: predicate) {
                return range.lowerBound ..< collection.index(after: new)
            } else {
                return range.lowerBound ..< collection.index(after: range.lowerBound)
            }
        case (.less, .same):
            let anchor = collection.index(before: range.upperBound)
            if let new = Self.first(collection, range: range.lowerBound ..< anchor, predicate: predicate) {
                return new ..< range.upperBound
            } else {
                return collection.index(before: range.upperBound) ..< range.upperBound
            }
        case (.less, .more), (.less, .less), (.more, .more):
            if let anchor = Self.any(collection, range: range.lowerBound ..< range.upperBound, predicate: predicate) {
                let first = Self.first(collection, range: range.lowerBound ..< anchor, predicate: predicate)
                let last = Self.last(collection, range: anchor ..< range.upperBound, predicate: predicate)
                if let first = first, let last = last {
                    return first ..< collection.index(after: last)
                } else if let first = first {
                    return first ..< collection.index(after: anchor)
                } else if let last = last {
                    return anchor ..< collection.index(after: last)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
}
    
private extension BinarySearch {
    
    static func _each< CollectionType : RandomAccessCollection >(
        _ collection: CollectionType,
        range: Range< CollectionType.Index >,
        predicate: (CollectionType.Element) -> Predicate
    ) -> Range< CollectionType.Index >? {
        var lower: CollectionType.Index?
        var upper: CollectionType.Index?
        do {
            var index = range.lowerBound
            while index < range.upperBound {
                switch predicate(collection[index]) {
                case .less, .more:
                    index = collection.index(after: index)
                case .same:
                    if lower == nil {
                        lower = index
                    } else {
                        upper = index
                    }
                    index = collection.index(after: index)
                }
            }
        }
        guard let lower = lower else {
            return nil
        }
        if let upper = upper {
            return lower ..< upper
        }
        return lower ..< collection.index(after: lower)
    }
    
}
