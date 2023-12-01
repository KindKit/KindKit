//
//  KindKit
//

import Foundation

public extension UI.Markdown.Parser {
    
    static func blocks(
        _ string: String
    ) -> [UI.Markdown.Block] {
        guard string.isEmpty == false else {
            return []
        }
        let tokens = Self.tokens(string)
        return Self.blocks(tokens)
    }
    
    static func blocks(
        _ tokens: [Token]
    ) -> [UI.Markdown.Block] {
        guard tokens.isEmpty == false else {
            return []
        }
        return Self._blocks(tokens)
    }
    
}

fileprivate extension UI.Markdown.Parser {
    
    struct Block {
        
        let level: UInt
        let content: [Token]
        
    }
    
    struct List {
        
        let marker: [Token]
        let content: [Token]
        
    }
    
    struct Paragraph {
        
        let content: [Token]
        
    }
    
}

fileprivate extension UI.Markdown.Parser {
    
    @inline(__always)
    static func _blocks(
        _ tokens: [Token]
    ) -> [UI.Markdown.Block] {
        var result: [UI.Markdown.Block] = []
        var tokens = tokens
        let endWith: [Character] = [ "$", "#", "[", ">" ]
        while tokens.isEmpty == false {
            if let block = Self._block(buffer: &tokens, startWith: "$", endWith: endWith) {
                result.append(.code(
                    level: block.level,
                    content: Self.text(block.content)
                ))
            } else if let block = Self._block(buffer: &tokens, startWith: "#", endWith: endWith) {
                result.append(.heading(
                    level: block.level,
                    content: Self.text(block.content)
                ))
            } else if let block = Self._list(buffer: &tokens, markerStart: "[", markerEnd: "]", endWith: endWith) {
                result.append(.list(
                    marker: Self.text(block.marker),
                    content: Self.text(block.content)
                ))
            } else if let block = Self._block(buffer: &tokens, startWith: ">", endWith: endWith) {
                result.append(.quote(
                    level: block.level,
                    content: Self.text(block.content)
                ))
            } else if let block = Self._paragraph(buffer: &tokens, endWith: endWith) {
                result.append(.paragraph(
                    content: Self.text(block.content)
                ))
            } else {
                tokens.removeFirst()
            }
        }
        return result
    }
    
    @inline(__always)
    static func _block(
        buffer: inout [Token],
        startWith: Character,
        endWith: [Character]
    ) -> Block? {
        guard buffer.count > 1 else {
            return nil
        }
        guard buffer[0] == .start else {
            return nil
        }
        guard let levelRange = Self.__levelRange(buffer: buffer, from: buffer.startIndex + 1, control: startWith) else {
            return nil
        }
        guard let skipRange = Self.__skipRange(buffer: buffer, from: levelRange.upperBound) else {
            return nil
        }
        guard let contentRange = Self.__contentRange(buffer: buffer, from: skipRange.upperBound, endWith: endWith) else {
            return nil
        }
        defer {
            buffer.removeFirst(contentRange.upperBound)
        }
        return .init(
            level: UInt(levelRange.upperBound - levelRange.lowerBound),
            content: Array(buffer[contentRange])
        )
    }
    
    @inline(__always)
    static func _list(
        buffer: inout [Token],
        markerStart: Character,
        markerEnd: Character,
        endWith: [Character]
    ) -> List? {
        guard buffer.count > 1 else {
            return nil
        }
        guard buffer[0] == .start && buffer[1] == .raw(markerStart) else {
            return nil
        }
        guard let beforeMarkerSkipRange = Self.__skipRange(buffer: buffer, from: buffer.startIndex + 2) else {
            return nil
        }
        guard let markerRange = Self.__contentRange(buffer: buffer, from: beforeMarkerSkipRange.upperBound, endWith: markerEnd) else {
            return nil
        }
        guard markerRange.lowerBound != markerRange.upperBound else {
            return nil
        }
        guard let afterMarkerSkipRange = Self.__skipRange(buffer: buffer, from: markerRange.upperBound + 1) else {
            return nil
        }
        guard let contentRange = Self.__contentRange(buffer: buffer, from: afterMarkerSkipRange.upperBound, endWith: endWith) else {
            return nil
        }
        defer {
            buffer.removeFirst(contentRange.upperBound)
        }
        return .init(
            marker: Array(buffer[markerRange]),
            content: Array(buffer[contentRange])
        )
    }
    
    @inline(__always)
    static func _paragraph(
        buffer: inout [Token],
        endWith: [Character]
    ) -> Paragraph? {
        guard buffer.count > 1 else {
            return nil
        }
        guard buffer[0] == .start else {
            return nil
        }
        guard let contentRange = Self.__contentRange(buffer: buffer, from: buffer.startIndex + 1, endWith: endWith) else {
            return nil
        }
        defer {
            buffer.removeFirst(contentRange.upperBound)
        }
        return .init(
            content: Array(buffer[contentRange])
        )
    }
    
    @inline(__always)
    static func __levelRange(
        buffer: [Token],
        from: Int,
        control: Character
    ) -> Range< Int >? {
        for index in from ..< buffer.endIndex {
            let token = buffer[index]
            switch token {
            case .start:
                return nil
            case .tab, .space:
                return .init(uncheckedBounds: (
                    lower: from,
                    upper: index
                ))
            case .escape:
                return nil
            case .raw(let char):
                if char != control {
                    return nil
                }
            case .end:
                return nil
            }
        }
        return nil
    }
    
    @inline(__always)
    static func __skipRange(
        buffer: [Token],
        from: Int
    ) -> Range< Int >? {
        for index in from ..< buffer.endIndex {
            let token = buffer[index]
            switch token {
            case .start:
                return nil
            case .tab, .space:
                break
            case .escape, .raw:
                return .init(uncheckedBounds: (
                    lower: from,
                    upper: index
                ))
            case .end:
                return nil
            }
        }
        return nil
    }
    
    @inline(__always)
    static func __contentRange(
        buffer: [Token],
        from: Int,
        endWith: Character
    ) -> Range< Int >? {
        var length = 0
        for index in from ..< buffer.endIndex {
            let token = buffer[index]
            switch token {
            case .start, .tab, .space, .escape:
                length += 1
            case .raw(let char):
                if endWith == char {
                    return .init(uncheckedBounds: (
                        lower: from,
                        upper: from + length
                    ))
                } else {
                    length += 1
                }
            case .end:
                return nil
            }
        }
        return .init(uncheckedBounds: (
            lower: from,
            upper: buffer.endIndex
        ))
    }
    
    @inline(__always)
    static func __contentRange(
        buffer: [Token],
        from: Int,
        endWith: [Character]
    ) -> Range< Int >? {
        var isStart = false
        var isEnd = false
        for index in from ..< buffer.endIndex {
            let token = buffer[index]
            switch token {
            case .start:
                isStart = true
            case .tab, .space, .escape:
                isStart = false
                isEnd = false
            case .raw(let char):
                if isEnd == true && endWith.contains(char) == true {
                    if isStart == true {
                        return .init(uncheckedBounds: (
                            lower: from,
                            upper: index - 2
                        ))
                    } else {
                        return .init(uncheckedBounds: (
                            lower: from,
                            upper: index - 1
                        ))
                    }
                }
                isStart = false
                isEnd = false
            case .end:
                if isEnd == true {
                    if isStart == true {
                        return .init(uncheckedBounds: (
                            lower: from,
                            upper: index - 2
                        ))
                    } else {
                        return .init(uncheckedBounds: (
                            lower: from,
                            upper: index - 1
                        ))
                    }
                }
                isEnd = true
            }
        }
        return .init(uncheckedBounds: (
            lower: from,
            upper: buffer.endIndex
        ))
    }
    
}
