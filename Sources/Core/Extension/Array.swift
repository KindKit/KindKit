//
//  KindKitCore
//

import Foundation

public extension Array {
    
    @inlinable
    func reorder(
        where block: (_ lhs: Element, _ rhs: Element) throws -> [Element]
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
    func reduce< Result >(
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
    func count(where: (_ element: Element) -> Bool) -> Int {
        var result = 0
        for element in self {
            if `where`(element) == true {
                result += 1
            }
        }
        return result
    }
    
    @inlinable
    func processing(
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
    func processing(
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
    
}
