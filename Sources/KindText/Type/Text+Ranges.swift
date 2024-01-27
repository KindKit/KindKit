//
//  KindKit
//

import KindCore

extension Text {
    
    public struct Ranges< ValueType : Equatable & Hashable > : Equatable, Hashable {
        
        public private(set) var items: [Item]
        
        public init() {
            self.items = []
        }
        
    }
    
}

public extension Text.Ranges {
    
    mutating func insert(
        _ position: Text.Index,
        _ count: Int
    ) {
        guard self.items.isEmpty == false else {
            return
        }
        var index = self.items.startIndex
        while index != self.items.endIndex {
            let item = self.items[index]
            if item.range.is(contains: position) == true {
                self.items[index].range = .init(
                    lower: item.range.lower,
                    upper: item.range.upper + count
                )
            } else if position <= item.range.lower {
                self.items[index].range = .init(
                    lower: item.range.lower + count,
                    upper: item.range.upper + count
                )
            }
            index = self.items.index(after: index)
        }
    }
    
    mutating func remove(
        _ range: Text.Range
    ) {
        guard self.items.isEmpty == false else {
            return
        }
        var index = self.items.startIndex
        while index != self.items.endIndex {
            let nextIndex = self.items.index(after: index)
            let item = self.items[index]
            if range == item.range {
                self.items.remove(at: index)
            } else if range.is(contains: item.range) == true {
                self.items.remove(at: index)
            } else if item.range.is(contains: range) == true {
                self.items[index].range = .init(
                    lower: item.range.lower,
                    upper: item.range.upper - range.count
                )
                index = nextIndex
            } else if item.range.is(contains: range.lower) == true {
                self.items[index].range = .init(
                    lower: item.range.lower,
                    upper: range.lower
                )
                index = nextIndex
            } else if item.range.is(contains: range.upper - 1) == true {
                self.items[index].range = .init(
                    lower: range.upper - range.count,
                    upper: item.range.upper - range.count
                )
                let prevIndex = self.items.index(before: index)
                if self.merge(prevIndex, index) == false {
                    index = nextIndex
                }
            } else if range.upper <= item.range.lower {
                self.items[index].range = .init(
                    lower: item.range.lower - range.count,
                    upper: item.range.upper - range.count
                )
                let prevIndex = self.items.index(before: index)
                if self.merge(prevIndex, index) == false {
                    index = nextIndex
                }
            } else {
                index = nextIndex
            }
        }
    }
    
    mutating func set(
        _ range: Text.Range,
        _ value: ValueType
    ) {
        var merges: [Int] = []
        var purposeIndex = self.items.startIndex
        if self.items.isEmpty == false {
            var index = self.items.startIndex
            while index != self.items.endIndex {
                let nextIndex = self.items.index(after: index)
                let item = self.items[index]
                if range.lower >= item.range.upper {
                    purposeIndex = nextIndex
                }
                if range == item.range {
                    merges.insert(index, at: merges.startIndex)
                    index = nextIndex
                } else if (range.lower == item.range.upper || range.upper == item.range.lower) {
                    if item.value == value {
                        merges.insert(index, at: merges.startIndex)
                    }
                    index = nextIndex
                } else if range.is(contains: item.range) == true {
                    self.items.remove(at: index)
                } else if item.range.is(contains: range.lower) == true {
                    merges.insert(index, at: merges.startIndex)
                    index = nextIndex
                } else if item.range.is(contains: range.upper - 1) == true {
                    merges.insert(index, at: merges.startIndex)
                    index = nextIndex
                } else {
                    index = nextIndex
                }
            }
        }
        if merges.count > 1 {
            var index = merges.startIndex
            var trailingIndex = merges[index]
            index = merges.index(after: index)
            while index != merges.endIndex {
                let leadingIndex = merges[index]
                self.set(leadingIndex, trailingIndex, range, value)
                index = merges.index(after: index)
                trailingIndex = leadingIndex
            }
        } else if merges.count == 1 {
            self.set(merges[0], range, value)
        } else {
            self.items.insert(.init(range: range, value: value), at: purposeIndex)
        }
    }
    
    mutating func clear(
        _ range: Text.Range
    ) {
        guard self.items.isEmpty == false else {
            return
        }
        var index = self.items.startIndex
        while index != self.items.endIndex {
            let nextIndex = self.items.index(after: index)
            let item = self.items[index]
            if range == item.range {
                self.items.remove(at: index)
            } else if range.is(contains: item.range) == true {
                self.items.remove(at: index)
            } else if item.range.is(contains: range) == true {
                self.items[index].range = .init(
                    lower: item.range.lower,
                    upper: range.lower
                )
                do {
                    let range = Text.Range(lower: range.upper, upper: item.range.upper)
                    self.items.insert(.init(range: range, value: item.value), at: nextIndex)
                }
                index = self.items.index(after: nextIndex)
            } else {
                var itemRange = item.range
                if itemRange.is(contains: range.lower) == true {
                    itemRange = .init(
                        lower: item.range.lower,
                        upper: range.lower
                    )
                }
                if itemRange.is(contains: range.upper - 1) == true {
                    itemRange = .init(
                        lower: range.upper,
                        upper: item.range.upper
                    )
                }
                if itemRange != item.range {
                    self.items[index].range = itemRange
                }
                index = nextIndex
            }
        }
    }
    
    @inlinable
    func item(at index: Text.Index) -> Item? {
        guard index < self.items.count else {
            return nil
        }
        return self.items[index]
    }
    
    @inlinable
    func items(of range: Text.Range) -> [Item] {
        guard let range = self.range(of: range) else {
            return []
        }
        return .init(self.items[range])
    }
    
    @inlinable
    func range(of range: Text.Range) -> Swift.Range< Int >? {
        return BinarySearch.range(self.items, predicate: { item in
            if range.lower > item.range.upper {
                return .less
            } else if range.upper < item.range.lower {
                return .more
            }
            return .same
        })
    }
    
}

fileprivate extension Text.Ranges {
    
    mutating func set(
        _ index: Int,
        _ range: Text.Range,
        _ value: ValueType
    ) {
        let item = self.items[index]
        if range == item.range {
            self.items[index] = .init(range: range, value: value)
        } else if range.lower == item.range.upper {
            self.items[index].range = .init(
                lower: item.range.lower,
                upper: range.upper
            )
        } else if range.upper == item.range.lower {
            self.items[index].range = .init(
                lower: range.lower,
                upper: item.range.upper
            )
        } else if range.lower == item.range.lower {
            self.items[index].range = .init(
                lower: range.upper,
                upper: item.range.upper
            )
            self.items.insert(.init(range: range, value: value), at: index)
        } else if range.upper == item.range.upper {
            self.items[index].range = .init(
                lower: item.range.lower,
                upper: range.lower
            )
            self.items.insert(.init(range: range, value: value), at: index + 1)
        } else {
            let ld = range.lower - item.range.lower
            let td = item.range.upper - range.upper
            if ld > 0 && td > 0 {
                do {
                    let range = Text.Range(lower: range.upper, upper: item.range.upper)
                    self.items.insert(.init(range: range, value: item.value), at: index + 1)
                }
                do {
                    self.items.insert(.init(range: range, value: value), at: index + 1)
                }
                do {
                    let range = Text.Range(lower: item.range.lower, upper: range.lower)
                    self.items[index] = .init(range: range, value: item.value)
                }
            } else if td > 0 {
                do {
                    let range = Text.Range(lower: range.upper, upper: item.range.upper)
                    self.items.insert(.init(range: range, value: item.value), at: index + 1)
                }
                do {
                    self.items[index] = .init(range: range, value: value)
                }
            } else {
                do {
                    self.items.insert(.init(range: range, value: value), at: index + 1)
                }
                do {
                    let range = Text.Range(lower: item.range.lower, upper: range.lower)
                    self.items[index] = .init(range: range, value: item.value)
                }
            }
        }
    }
    
    mutating func set(
        _ leadingIndex: Int,
        _ trailingIndex: Int,
        _ range: Text.Range,
        _ value: ValueType
    ) {
        let leading = self.items[leadingIndex]
        let trailing = self.items[trailingIndex]
        if leading.value == value && trailing.value == value {
            self.items[leadingIndex].range = .init(
                lower: leading.range.lower,
                upper: trailing.range.upper
            )
            self.items.remove(at: trailingIndex)
        } else {
            self.items[leadingIndex].range = .init(
                lower: leading.range.lower,
                upper: range.lower
            )
            self.items[trailingIndex].range = .init(
                lower: range.upper,
                upper: trailing.range.upper
            )
            self.items.insert(.init(range: range, value: value), at: trailingIndex)
        }
    }
    
    mutating func merge(
        _ leadingIndex: Int,
        _ trailingIndex: Int
    ) -> Bool {
        guard leadingIndex != trailingIndex else {
            return false
        }
        let leading = self.items[leadingIndex]
        let trailing = self.items[trailingIndex]
        guard leading.value == trailing.value else {
            return false
        }
        self.items[leadingIndex].range = .init(
            lower: leading.range.lower,
            upper: trailing.range.upper
        )
        self.items.remove(at: trailingIndex)
        return true
    }
    
}
