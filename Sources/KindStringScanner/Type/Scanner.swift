//
//  KindKit
//

import Foundation
import KindString

public final class Scanner {
    
    public private(set) var buffer: String
    
    public private(set) var index: String.Index
    
    public var startIndex: String.Index {
        return self.buffer.startIndex
    }
    
    public var endIndex: String.Index {
        return self.buffer.endIndex
    }
    
    public var isAtEnd: Bool {
        return self.index == self.buffer.endIndex
    }
    
    public var remainder: String {
        return .init(self.buffer[self.remainderRange])
    }
    
    public var remainderRange: Range {
        return self.index ..< self.endIndex
    }
    
    public var remainderLength: Int {
        return self.buffer.distance(
            from: self.buffer.startIndex,
            to: self.buffer.endIndex
        )
    }
    
    public init(_ buffer: String) {
        self.buffer = buffer
        self.index = self.buffer.startIndex
    }
    
}

public extension Scanner {
    
    func scope(flags: Scope, _ block: () throws -> Void) rethrows {
        let index = self.index
        do {
            try block()
            if flags.contains(.restoreAfterFinish) == true {
                self.index = index
            }
        } catch let error {
            if flags.contains(.restoreAfterException) == true {
                self.index = index
            }
            throw error
        }
    }
    
    func scope< ResultType >(flags: Scope, _ block: () throws -> ResultType) rethrows -> ResultType {
        let index = self.index
        do {
            let result = try block()
            if flags.contains(.restoreAfterFinish) == true {
                self.index = index
            }
            return result
        } catch let error {
            if flags.contains(.restoreAfterException) == true {
                self.index = index
            }
            throw error
        }
    }
    
}

public extension Scanner {
    
    @discardableResult
    func match(_ character: Character) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard Self._match(in: self.buffer, from: self.index, match: character) == true else { return nil }
        let range = self.index ..< self.buffer.index(after: self.index)
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func match(_ character: [Character]) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard Self._match(in: self.buffer, from: self.index, match: character) == true else { return nil }
        let range = self.index ..< self.buffer.index(after: self.index)
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func match(_ characterSet: CharacterSet) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard Self._match(in: self.buffer, from: self.index, match: characterSet) == true else { return nil }
        let range = self.index ..< self.buffer.index(after: self.index)
        self.index = self.buffer.index(after: self.index)
        return self._result(range)
    }
    
    @discardableResult
    func match(_ string: String) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._match(in: self.buffer, from: self.index, match: string) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func match(_ strings: [String]) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._match(in: self.buffer, from: self.index, match: strings) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
}

public extension Scanner {
    
    @discardableResult
    func next() -> Result? {
        guard self.isAtEnd == false else { return nil }
        let range = self.index ..< self.buffer.index(after: self.index)
        let result = Result(range: range, content: self.buffer[range])
        self.index = range.upperBound
        return result
    }
    
    @discardableResult
    func next(length: Int) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, length: length) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(to: (Character) -> Bool) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, to: to) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(to: Character) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, to: to) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(to: [Character]) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, to: to) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(to: CharacterSet) -> Result? {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, to: to) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(to: String) -> Result? {
        guard to.isEmpty == false && self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, to: to) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(to: [String]) -> Result? {
        guard to.isEmpty == false && self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, to: to) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(until: Character) -> Result?  {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, until: until) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(until: [Character]) -> Result?  {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, until: until) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(until: CharacterSet) -> Result?  {
        guard self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, until: until) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(until: String) -> Result? {
        guard until.isEmpty == false && self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, until: until) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
    @discardableResult
    func next(until: [String]) -> Result? {
        guard until.isEmpty == false && self.isAtEnd == false else { return nil }
        guard let range = Self._range(in: self.buffer, from: self.index, until: until) else { return nil }
        self.index = range.upperBound
        return self._result(range)
    }
    
}

public extension Scanner {
    
    @discardableResult
    func backward(_ offset: Int) -> Int {
        var accumulated = 0
        while accumulated < offset && self.index != self.buffer.startIndex {
            self.index = self.buffer.index(before: self.index)
            accumulated += 1
        }
        return accumulated
    }
    
}

public extension Scanner {
    
    func reset() {
        self.index = self.buffer.startIndex
    }
    
}

private extension Scanner {
    
    @inline(__always)
    func _result(_ range: Range) -> Result {
        return .init(range: range, content: self.buffer[range])
    }
    
}

private extension Scanner {
    
    @inline(__always)
    static func _match(
        in buffer: String,
        from: String.Index,
        match target: Character
    ) -> Bool {
        return buffer[from] == target
    }
    
    @inline(__always)
    static func _match(
        in buffer: String,
        from: String.Index,
        match targets: [Character]
    ) -> Bool {
        return targets.contains(buffer[from])
    }
    
    @inline(__always)
    static func _match(
        in buffer: String,
        from: String.Index,
        match target: CharacterSet
    ) -> Bool {
        return target.kk_contains(buffer[from])
    }
    
    @inline(__always)
    static func _match(
        in buffer: String,
        from: String.Index,
        match target: String
    ) -> Range? {
        let bufferIndex = from
        if buffer[bufferIndex] == target[target.startIndex] {
            var tempTargetIndex = target.index(after: target.startIndex)
            var tempBufferIndex = buffer.index(after: bufferIndex)
            while tempTargetIndex != target.endIndex && tempBufferIndex != buffer.endIndex {
                if target[tempTargetIndex] != buffer[tempBufferIndex] {
                    break
                }
                tempTargetIndex = target.index(after: tempTargetIndex)
                tempBufferIndex = buffer.index(after: tempBufferIndex)
            }
            if tempTargetIndex == target.endIndex {
                return from ..< buffer.index(from, offsetBy: target.count)
            }
        }
        return nil
    }
    
    @inline(__always)
    static func _match(
        in buffer: String,
        from: String.Index,
        match targets: [String]
    ) -> Range? {
        let bufferIndex = from
        for targetIndex in 0 ..< targets.count {
            let target = targets[targetIndex]
            if buffer[bufferIndex] == target[target.startIndex] {
                var tempTargetIndex = target.index(after: target.startIndex)
                var tempBufferIndex = buffer.index(after: bufferIndex)
                while tempTargetIndex != target.endIndex && tempBufferIndex != buffer.endIndex {
                    if target[tempTargetIndex] != buffer[tempBufferIndex] {
                        break
                    }
                    tempTargetIndex = target.index(after: tempTargetIndex)
                    tempBufferIndex = buffer.index(after: tempBufferIndex)
                }
                if tempTargetIndex == target.endIndex {
                    return from ..< buffer.index(from, offsetBy: target.count)
                }
            }
        }
        return nil
    }
    
}

private extension Scanner {
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        length: Int
    ) -> Range? {
        var bufferIndex = from
        var remaining = length
        while remaining > 0 && bufferIndex != buffer.endIndex {
            bufferIndex = buffer.index(after: bufferIndex)
            remaining -= 1
        }
        return from ..< bufferIndex
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        to: (Character) -> Bool
    ) -> Range? {
        var bufferIndex = from
        while bufferIndex != buffer.endIndex {
            if to(buffer[bufferIndex]) == true {
                break
            }
            bufferIndex = buffer.index(after: bufferIndex)
        }
        return from ..< bufferIndex
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        to target: Character
    ) -> Range? {
        return self._range(in: buffer, from: from, to: { target == $0 })
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        to target: [Character]
    ) -> Range? {
        return self._range(in: buffer, from: from, to: { target.contains($0) })
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        to target: CharacterSet
    ) -> Range? {
        return self._range(in: buffer, from: from, to: { target.kk_contains($0) })
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        to target: String
    ) -> Range? {
        var bufferIndex = from
        while bufferIndex != buffer.endIndex {
            let nextBufferIndex = buffer.index(after: bufferIndex)
            if buffer[bufferIndex] == target[target.startIndex] {
                var tempTargetIndex = target.index(after: target.startIndex)
                var tempBufferIndex = nextBufferIndex
                while tempTargetIndex != target.endIndex && tempBufferIndex != buffer.endIndex {
                    if target[tempTargetIndex] != buffer[tempBufferIndex] {
                        break
                    }
                    tempTargetIndex = target.index(after: tempTargetIndex)
                    tempBufferIndex = buffer.index(after: tempBufferIndex)
                }
                if tempTargetIndex == target.endIndex {
                    return from ..< bufferIndex
                }
            }
            bufferIndex = nextBufferIndex
        }
        return from ..< bufferIndex
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        to targets: [String]
    ) -> Range? {
        var bufferIndex = from
        while bufferIndex != buffer.endIndex {
            let nextBufferIndex = buffer.index(after: bufferIndex)
            for targetIndex in 0 ..< targets.count {
                let target = targets[targetIndex]
                if buffer[bufferIndex] == target[target.startIndex] {
                    var tempTargetIndex = target.index(after: target.startIndex)
                    var tempBufferIndex = nextBufferIndex
                    while tempTargetIndex != target.endIndex && tempBufferIndex != buffer.endIndex {
                        if target[tempTargetIndex] != buffer[tempBufferIndex] {
                            break
                        }
                        tempTargetIndex = target.index(after: tempTargetIndex)
                        tempBufferIndex = buffer.index(after: tempBufferIndex)
                    }
                    if tempTargetIndex == target.endIndex {
                        return from ..< bufferIndex
                    }
                }
            }
            bufferIndex = nextBufferIndex
        }
        return from ..< bufferIndex
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        until target: Character
    ) -> Range? {
        return self._range(in: buffer, from: from, to: { target != $0 })
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        until targets: [Character]
    ) -> Range? {
        return self._range(in: buffer, from: from, to: { !targets.contains($0) })
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        until target: CharacterSet
    ) -> Range? {
        return self._range(in: buffer, from: from, to: { !target.kk_contains($0) })
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        until target: String
    ) -> Range? {
        var bufferIndex = from
        while bufferIndex != buffer.endIndex {
            let nextBufferIndex = buffer.index(after: bufferIndex)
            if buffer[bufferIndex] == target[target.startIndex] {
                var tempTargetIndex = target.index(after: target.startIndex)
                var tempBufferIndex = nextBufferIndex
                while tempTargetIndex != target.endIndex && tempBufferIndex != buffer.endIndex {
                    if target[tempTargetIndex] != buffer[tempBufferIndex] {
                        break
                    }
                    tempTargetIndex = target.index(after: tempTargetIndex)
                    tempBufferIndex = buffer.index(after: tempBufferIndex)
                }
                if tempTargetIndex == target.endIndex {
                    bufferIndex = nextBufferIndex
                } else {
                    return from ..< bufferIndex
                }
            } else {
                return from ..< bufferIndex
            }
        }
        return from ..< bufferIndex
    }
    
    @inline(__always)
    static func _range(
        in buffer: String,
        from: String.Index,
        until targets: [String]
    ) -> Range? {
        var bufferIndex = from
        while bufferIndex != buffer.endIndex {
            let nextBufferIndex = buffer.index(after: bufferIndex)
            for targetIndex in 0 ..< targets.count {
                let target = targets[targetIndex]
                if buffer[bufferIndex] == target[target.startIndex] {
                    var tempTargetIndex = target.index(after: target.startIndex)
                    var tempBufferIndex = nextBufferIndex
                    while tempTargetIndex != target.endIndex && tempBufferIndex != buffer.endIndex {
                        if target[tempTargetIndex] != buffer[tempBufferIndex] {
                            break
                        }
                        tempTargetIndex = target.index(after: tempTargetIndex)
                        tempBufferIndex = buffer.index(after: tempBufferIndex)
                    }
                    if tempTargetIndex == target.endIndex {
                        bufferIndex = nextBufferIndex
                    } else {
                        return from ..< bufferIndex
                    }
                } else {
                    return from ..< bufferIndex
                }
            }
        }
        return from ..< bufferIndex
    }
    
}
