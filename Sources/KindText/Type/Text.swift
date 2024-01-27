//
//  KindKit
//

import Foundation
import KindEvent
import KindGraphics

public struct Text : Equatable, Hashable {
    
    public var string: String
    
    var extra = Extra()
    
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
        @ComponentsBuilder _ builder: () -> [IComponent]
    ) {
        self.init()
        for component in builder() {
            self.append(component.text)
        }
    }
    
}

public extension Text {
    
    var count: Int {
        return self.string.count
    }
    
    var startIndex: Text.Index {
        return 0
    }
    
    var endIndex: Text.Index {
        return self.string.count
    }
    
    @inlinable
    var range: Text.Range {
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

public extension Text {
    
    func link(at index: Text.Index) -> URL? {
        return self.extra.link(at: index)
    }
    
    func each(base: Style, _ block: (Text.Range, Text.Options) -> Void) {
        self.extra.each(.init(style: base), self.range, block)
    }
    
}

public extension Text {
    
    @discardableResult
    mutating func prepend(_ string: String) -> Text.Range {
        return self.insert(string, at: self.startIndex)
    }
    
    @discardableResult
    mutating func prepend(_ text: Text) -> Text.Range {
        return self.insert(text, at: self.startIndex)
    }
    
}

public extension Text {
    
    @discardableResult
    mutating func append(_ string: String) -> Text.Range {
        return self.insert(string, at: self.endIndex)
    }
    
    @discardableResult
    mutating func append(_ text: Text) -> Text.Range {
        return self.insert(text, at: self.endIndex)
    }
    
}

public extension Text {
    
    @discardableResult
    mutating func insert(_ string: String, at index: String.Index) -> Text.Range {
        let index = max(self.string.startIndex, min(index, self.string.endIndex))
        let i = self.string.distance(from: self.string.startIndex, to: index)
        self._insert(string, at: index)
        self.extra.insert(i, string.count)
        return .init(location: i, count: string.count)
    }
    
    @discardableResult
    mutating func insert(_ string: String, at index: Text.Index) -> Text.Range {
        let index = max(self.startIndex, min(index, self.endIndex))
        self._insert(string, at: index)
        self.extra.insert(index, string.count)
        return .init(location: index, count: string.count)
    }
    
    @discardableResult
    mutating func insert(_ text: Text, at index: String.Index) -> Text.Range {
        let index = max(self.string.startIndex, min(index, self.string.endIndex))
        let i = self.string.distance(from: self.string.startIndex, to: index)
        self._insert(text.string, at: index)
        self.extra.insert(i, text.count, text.extra)
        return .init(location: i, count: text.count)
    }
    
    @discardableResult
    mutating func insert(_ text: Text, at index: Text.Index) -> Text.Range {
        let index = max(self.startIndex, min(index, self.endIndex))
        self._insert(text.string, at: index)
        self.extra.insert(index, text.count, text.extra)
        return .init(location: index, count: text.count)
    }
    
}

public extension Text {
    
    @discardableResult
    mutating func replace(_ string: String, `in` range: Swift.Range< String.Index >) -> Text.Range {
        let range = Text.Range(range, in: self.string)
        return self.replace(string, in: range)
    }
    
    @discardableResult
    mutating func replace(_ string: String, `in` range: Text.Range) -> Text.Range {
        self.remove(in: range)
        return self.insert(string, at: range.lower)
    }
    
    @discardableResult
    mutating func replace(_ text: Text, `in` range: Swift.Range< String.Index >) -> Text.Range {
        let range = Text.Range(range, in: self.string)
        return self.replace(text, in: range)
    }
    
    @discardableResult
    mutating func replace(_ text: Text, `in` range: Text.Range) -> Text.Range {
        self.remove(in: range)
        return self.insert(text, at: range.lower)
    }
    
}

public extension Text {
    
    mutating func remove(`in` range: Swift.Range< String.Index >) {
        self.remove(in: .init(range, in: self.string))
    }
    
    mutating func remove(`in` range: Text.Range) {
        guard range.lower != range.upper else { return }
        let lower = max(self.startIndex, min(range.lower, self.endIndex))
        let upper = max(self.startIndex, min(range.upper, self.endIndex))
        let range = Range(lower: lower, upper: upper)
        self._remove(in: range)
        self.extra.remove(range)
    }
    
}

public extension Text {
    
    mutating func set(options: Text.Options, `in` range: Swift.Range< String.Index >) {
        self.set(options: options, in: .init(range, in: self.string))
    }
    
    mutating func set(options: Text.Options, `in` range: Text.Range) {
        guard range.lower != range.upper else { return }
        let lower = max(self.startIndex, min(range.lower, self.endIndex))
        let upper = max(self.startIndex, min(range.upper, self.endIndex))
        self.extra.set(.init(lower: lower, upper: upper), options.enum)
    }
    
    mutating func clear(options: Text.OptionSet, `in` range: Swift.Range< String.Index >) {
        self.clear(options: options, in: .init(range, in: self.string))
    }
    
    mutating func clear(options: Text.OptionSet, `in` range: Text.Range) {
        guard range.lower != range.upper else { return }
        let lower = max(self.startIndex, min(range.lower, self.endIndex))
        let upper = max(self.startIndex, min(range.upper, self.endIndex))
        self.extra.clear(.init(lower: lower, upper: upper), options)
    }
    
}

fileprivate extension Text {
    
    mutating func _insert(_ string: String, at index: String.Index) {
        self.string.insert(contentsOf: string, at: index)
    }
    
    mutating func _insert(_ string: String, at index: Text.Index) {
        let index = self.string.index(self.string.startIndex, offsetBy: index)
        self._insert(string, at: index)
    }
    
    mutating func _remove(`in` range: Swift.Range< String.Index >) {
        self.string.removeSubrange(range)
    }
    
    mutating func _remove(`in` range: Text.Range) {
        let lower = self.string.index(self.string.startIndex, offsetBy: range.lower)
        let upper = self.string.index(self.string.startIndex, offsetBy: range.upper)
        self._remove(in: lower ..< upper)
    }
    
}
