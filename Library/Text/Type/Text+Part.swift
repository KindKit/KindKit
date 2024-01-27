//
//  KindKit
//

import Foundation
import KindEvent
import KindGraphics

extension Text {
    
    public struct Part {
        
        public var string: String
        
        var extra = Text.Part.Extra()
        
        public init(
            _ string: Swift.String = "",
            options: Options? = nil
        ) {
            self.string = string
            if let options = options, options.isEmpty == false {
                self.set(options: options, in: self.range)
            }
        }
        
        public init(
            @ComponentsBuilder _ builder: () -> [any Component]
        ) {
            self.init()
            for component in builder() {
                self.append(component.part)
            }
        }
        
    }
    
}

extension Text.Part : Hashable {
}

extension Text.Part : Equatable {
}

extension Text.Part : Sendable {
}

public extension Text.Part {
    
    @inlinable
    static var empty: Self {
        return .init()
    }
    
}

public extension Text.Part {

    var count: Int {
        return self.string.count
    }
    
    var startIndex: Text.Part.Index {
        return 0
    }
    
    var endIndex: Text.Part.Index {
        return self.string.count
    }
    
    @inlinable
    var range: Text.Part.Range {
        return .init(
            lower: self.startIndex,
            upper: self.endIndex
        )
    }
    
    var styles: [Style] {
        return self.extra.usageStyles
    }
    
    var shouldLink: Bool {
        return self.extra.shouldLink
    }
    
}

public extension Text.Part {
    
    func link(at index: Index) -> URL? {
        return self.extra.link(at: index)
    }
    
    func each(base: Style, _ block: (Text.Part.Range, Options) -> Void) {
        self.extra.each(.init(style: base), self.range, block)
    }
    
}

public extension Text.Part {
    
    @discardableResult
    mutating func prepend(_ string: String) -> Text.Part.Range {
        return self.insert(string, at: self.startIndex)
    }
    
    @discardableResult
    mutating func prepend(_ part: Text.Part) -> Text.Part.Range {
        return self.insert(part, at: self.startIndex)
    }
    
}

public extension Text.Part {
    
    @discardableResult
    mutating func append(_ string: String) -> Text.Part.Range {
        return self.insert(string, at: self.endIndex)
    }
    
    @discardableResult
    mutating func append(_ part: Text.Part) -> Text.Part.Range {
        return self.insert(part, at: self.endIndex)
    }
    
}

public extension Text.Part {
    
    @discardableResult
    mutating func insert(_ string: String, at index: String.Index) -> Text.Part.Range {
        let index = max(self.string.startIndex, min(index, self.string.endIndex))
        let i = self.string.distance(from: self.string.startIndex, to: index)
        self._insert(string, at: index)
        self.extra.insert(i, string.count)
        return .init(location: i, count: string.count)
    }
    
    @discardableResult
    mutating func insert(_ string: String, at index: Text.Part.Index) -> Text.Part.Range {
        let index = max(self.startIndex, min(index, self.endIndex))
        self._insert(string, at: index)
        self.extra.insert(index, string.count)
        return .init(location: index, count: string.count)
    }
    
    @discardableResult
    mutating func insert(_ part: Text.Part, at index: String.Index) -> Text.Part.Range {
        let index = max(self.string.startIndex, min(index, self.string.endIndex))
        let i = self.string.distance(from: self.string.startIndex, to: index)
        self._insert(part.string, at: index)
        self.extra.insert(i, part.count, part.extra)
        return .init(location: i, count: part.count)
    }
    
    @discardableResult
    mutating func insert(_ part: Text.Part, at index: Text.Part.Index) -> Text.Part.Range {
        let index = max(self.startIndex, min(index, self.endIndex))
        self._insert(part.string, at: index)
        self.extra.insert(index, part.count, part.extra)
        return .init(location: index, count: part.count)
    }
    
}

public extension Text.Part {
    
    @discardableResult
    mutating func replace(_ string: String, `in` range: Swift.Range< String.Index >) -> Text.Part.Range {
        let range = Range(range, in: self.string)
        return self.replace(string, in: range)
    }
    
    @discardableResult
    mutating func replace(_ string: String, `in` range: Text.Part.Range) -> Text.Part.Range {
        self.remove(in: range)
        return self.insert(string, at: range.lower)
    }
    
    @discardableResult
    mutating func replace(_ part: Text.Part, `in` range: Swift.Range< String.Index >) -> Text.Part.Range {
        let range = Range(range, in: self.string)
        return self.replace(part, in: range)
    }
    
    @discardableResult
    mutating func replace(_ part: Text.Part, `in` range: Text.Part.Range) -> Text.Part.Range {
        self.remove(in: range)
        return self.insert(part, at: range.lower)
    }
    
}

public extension Text.Part {
    
    mutating func remove(`in` range: Swift.Range< String.Index >) {
        self.remove(in: .init(range, in: self.string))
    }
    
    mutating func remove(`in` range: Text.Part.Range) {
        guard range.lower != range.upper else { return }
        let lower = max(self.startIndex, min(range.lower, self.endIndex))
        let upper = max(self.startIndex, min(range.upper, self.endIndex))
        let range = Range(lower: lower, upper: upper)
        self._remove(in: range)
        self.extra.remove(range)
    }
    
}

public extension Text.Part {
    
    mutating func set(options: Options, `in` range: Swift.Range< String.Index >) {
        self.set(options: options, in: .init(range, in: self.string))
    }
    
    mutating func set(options: Options, `in` range: Text.Part.Range) {
        guard range.lower != range.upper else { return }
        let lower = max(self.startIndex, min(range.lower, self.endIndex))
        let upper = max(self.startIndex, min(range.upper, self.endIndex))
        self.extra.set(.init(lower: lower, upper: upper), options.enum)
    }
    
    mutating func clear(options: OptionSet, `in` range: Swift.Range< String.Index >) {
        self.clear(options: options, in: .init(range, in: self.string))
    }
    
    mutating func clear(options: OptionSet, `in` range: Text.Part.Range) {
        guard range.lower != range.upper else { return }
        let lower = max(self.startIndex, min(range.lower, self.endIndex))
        let upper = max(self.startIndex, min(range.upper, self.endIndex))
        self.extra.clear(.init(lower: lower, upper: upper), options)
    }
    
}

fileprivate extension Text.Part {
    
    mutating func _insert(_ string: String, at index: String.Index) {
        self.string.insert(contentsOf: string, at: index)
    }
    
    mutating func _insert(_ string: String, at index: Index) {
        let index = self.string.index(self.string.startIndex, offsetBy: index)
        self._insert(string, at: index)
    }
    
    mutating func _remove(`in` range: Swift.Range< String.Index >) {
        self.string.removeSubrange(range)
    }
    
    mutating func _remove(`in` range: Text.Part.Range) {
        let lower = self.string.index(self.string.startIndex, offsetBy: range.lower)
        let upper = self.string.index(self.string.startIndex, offsetBy: range.upper)
        self._remove(in: lower ..< upper)
    }
    
}
