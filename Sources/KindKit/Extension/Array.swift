//
//  KindKit
//

import Foundation

public extension Array {
    
    @inlinable
    static func kk_make(
        range: Range< Element >
    ) -> Self where Element : Strideable, Element.Stride : SignedInteger {
        return Array(unsafeUninitializedCapacity: range.count, initializingWith: { buffer, count in
            for (index, value) in range.enumerated() {
                buffer[index] = value
            }
            count = range.count
        })
    }
    
    @inlinable
    func kk_uniqued() -> Self where Element : Hashable {
        var exist = Set< Element >()
        var result = Array()
        for element in self {
            if exist.contains(element) == false {
                result.append(element)
                exist.insert(element)
            }
        }
        return result
    }
    
    @inlinable
    func kk_uniqued(
        `where`: (Element, Element) -> Bool
    ) -> Self {
        var exist: [Element] = []
        var result = Array()
        for element in self {
            if exist.contains(where: { `where`(element, $0) }) == false {
                result.append(element)
                exist.append(element)
            }
        }
        return result
    }
    
    @inlinable
    func kk_previous(
        `where`: (Element) -> Bool
    ) -> Element? {
        guard let index = self.firstIndex(where: `where`) else {
            return nil
        }
        guard index > 0 else {
            return nil
        }
        return self[index - 1]
    }
    
    @inlinable
    func kk_previous(
        at index: Int
    ) -> Element? {
        guard index > 0 && index < self.count else {
            return nil
        }
        return self[index - 1]
    }
    
    @inlinable
    func kk_next(
        `where`: (Element) -> Bool
    ) -> Element? {
        guard let index = self.firstIndex(where: `where`) else {
            return nil
        }
        guard index < self.count - 1 else {
            return nil
        }
        return self[index + 1]
    }
    
    @inlinable
    func kk_next(
        at index: Int
    ) -> Element? {
        guard index < self.count - 1 else {
            return nil
        }
        return self[index + 1]
    }
    
    @inlinable
    func kk_appending(
        _ element: Element
    ) -> Self {
        if self.isEmpty == true {
            return [ element ]
        }
        var result = self
        result.append(element)
        return result
    }
    
    @inlinable
    func kk_appending< S : Sequence >(
        contentsOf contents: S
    ) -> Self  where Element == S.Element {
        if self.isEmpty == true {
            return Array(contents)
        }
        var result = self
        result.append(contentsOf: contents)
        return result
    }
    
    @inlinable
    func kk_removingFirst(
        count: Int = 1
    ) -> Self {
        if self.count < count {
            return []
        }
        var result = self
        result.removeFirst(count)
        return result
    }
    
    @inlinable
    func kk_removingLast(
        count: Int = 1
    ) -> Self {
        if self.count < count {
            return []
        }
        var result = self
        result.removeLast(count)
        return result
    }
    
    @inlinable
    func kk_replacing(
        at index: Self.Index,
        to element: Element
    ) -> Self {
        var result = self
        result[index] = element
        return result
    }
    
    @inlinable
    func kk_reorder(
        `where` block: (_ lhs: Element, _ rhs: Element) throws -> [Element]
    ) rethrows -> Self {
        guard self.count > 1 else { return self }
        var result: [Element] = []
        var index = 1
        while index < self.endIndex {
            let lhs = self[index - 1]
            let rhs = self[index]
            result.append(contentsOf: try block(lhs, rhs))
            index += 1
        }
        return result
    }
    
    @inlinable
    func kk_reduce< Result >(
        _ emptyResult: () throws -> Result,
        _ firstResult: (Element) throws -> Result,
        _ nextResult: (Result, Element) throws -> Result
    ) rethrows -> Result {
        if self.count > 1 {
            return try self[1 ..< self.endIndex].reduce(try firstResult(self[0]), nextResult)
        } else if self.count > 0 {
            return try firstResult(self[0])
        }
        return try emptyResult()
    }
    
    @inlinable
    func kk_count(
        _ element: Element
    ) -> Int where Element : Equatable {
        return self.kk_count(where: { $0 == element })
    }
    
    @inlinable
    func kk_count(
        `where`: (Element) -> Bool
    ) -> Int {
        var result = 0
        for element in self {
            if `where`(element) == true {
                result += 1
            }
        }
        return result
    }
    
    @inlinable
    func kk_processing(
        prefix: (() throws -> Element?)? = nil,
        suffix: (() throws -> Element?)? = nil,
        separator: (() throws -> Element?)?
    ) rethrows -> Self {
        var result: [Element] = []
        if prefix != nil {
            if let item = try prefix?() {
                result.append(item)
            }
        }
        if separator != nil {
            if self.count > 1 {
                for item in self[0 ..< self.count - 1] {
                    result.append(item)
                    if let item = try separator?() {
                        result.append(item)
                    }
                }
                result.append(self[self.count - 1])
            } else if self.count > 0 {
                result.append(self[0])
            }
        } else {
            result.append(contentsOf: self)
        }
        if suffix != nil {
            if let item = try suffix?() {
                result.append(item)
            }
        }
        return result
    }
    
    @inlinable
    func kk_processing(
        prefix: (() throws -> [Element])? = nil,
        suffix: (() throws -> [Element])? = nil,
        separator: (() throws -> [Element])?
    ) rethrows -> [Element] {
        var result: [Element] = []
        if prefix != nil {
            if let items = try prefix?() {
                result.append(contentsOf: items)
            }
        }
        if separator != nil {
            if self.count > 1 {
                for item in self[0 ..< self.count - 1] {
                    result.append(item)
                    if let items = try separator?() {
                        result.append(contentsOf: items)
                    }
                }
                result.append(self[self.count - 1])
            } else if self.count > 0 {
                result.append(self[0])
            }
        } else {
            result.append(contentsOf: self)
        }
        if suffix != nil {
            if let items = try suffix?() {
                result.append(contentsOf: items)
            }
        }
        return result
    }
    
    @inlinable
    func kk_difference(
        _ other: [Element],
        `where`: (Element, Element) -> Bool
    ) -> (
        removed: [Element],
        stayed: [Element],
        added: [Element]
    ) {
        return (
            removed: self.filter({ view in
                other.contains(where: { `where`($0, view) }) == false
            }),
            stayed: self.filter({ view in
                other.contains(where: { `where`($0, view) }) == true
            }),
            added: other.filter({ view in
                self.contains(where: { `where`($0, view) }) == false
            })
        )
    }
    
    @inlinable
    func kk_stride(size: Int) -> [[Element]] where Element : Hashable {
        return stride(from: 0, to: self.count, by: size).map({
            let from = $0
            let to = Swift.min(from.advanced(by: size), self.endIndex)
            return Array(self[from..<to])
        })
    }
    
}
