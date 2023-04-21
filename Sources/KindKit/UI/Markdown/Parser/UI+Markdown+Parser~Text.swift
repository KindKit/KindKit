//
//  KindKit
//

import Foundation

public extension UI.Markdown.Parser {
    
    static func text(
        _ string: String
    ) -> UI.Markdown.Text {
        guard string.isEmpty == false else {
            return .text([])
        }
        let tokens = Self.tokens(string)
        return Self.text(tokens)
    }
    
    static func text(
        _ tokens: [Token]
    ) -> UI.Markdown.Text {
        guard tokens.isEmpty == false else {
            return .text([])
        }
        let tokens = Self._textTokens(tokens)
        guard tokens.isEmpty == false else {
            return .text([])
        }
        return .text(Self._parts(tokens))
    }
    
}

fileprivate extension UI.Markdown.Parser {
    
    enum TextToken : Equatable {
        
        case control(Control)
        case char(Character)
        
    }
    
    enum Control : Equatable {
        
        case simple(Simple)
        case openBracket(Bracket)
        case closeBracket(Bracket)
        
    }
    
    enum Simple : Equatable {
        
        /// /
        case italic
        
        /// *
        case bold
        
        /// _
        case underline
        
        /// -
        case strikethrough
        
    }
    
    enum Bracket : Equatable {
        
        /// ( or )
        case round
        
        /// [ or ]
        case square
        
    }
    
}

fileprivate extension UI.Markdown.Parser {
    
    static func _textTokens(
        _ tokens: [Token]
    ) -> [TextToken] {
        var result: [TextToken] = []
        var prevChar: Character? = nil
        for token in tokens {
            switch token {
            case .start:
                if let char = prevChar {
                    prevChar = nil
                    result.append(.char(char))
                }
            case .tab:
                if let char = prevChar {
                    prevChar = nil
                    result.append(.char(char))
                }
                result.append(.char("\t"))
            case .space:
                if let char = prevChar {
                    prevChar = nil
                    result.append(.char(char))
                }
                result.append(.char(" "))
            case .escape(let char):
                if let char = prevChar {
                    prevChar = nil
                    result.append(.char(char))
                }
                result.append(.char(char))
            case .raw(let currChar):
                if currChar == "/" {
                    if let char = prevChar {
                        prevChar = nil
                        if currChar == char {
                            result.append(.control(.simple(.italic)))
                        } else {
                            result.append(.char(char))
                            result.append(.char(currChar))
                        }
                    } else {
                        prevChar = currChar
                    }
                } else if currChar == "*" {
                    if let char = prevChar {
                        prevChar = nil
                        if currChar == char {
                            result.append(.control(.simple(.bold)))
                        } else {
                            result.append(.char(char))
                            result.append(.char(currChar))
                        }
                    } else {
                        prevChar = currChar
                    }
                } else if currChar == "_" {
                    if let char = prevChar {
                        prevChar = nil
                        if currChar == char {
                            result.append(.control(.simple(.underline)))
                        } else {
                            result.append(.char(char))
                            result.append(.char(currChar))
                        }
                    } else {
                        prevChar = currChar
                    }
                } else if currChar == "-" {
                    if let char = prevChar {
                        prevChar = nil
                        if currChar == char {
                            result.append(.control(.simple(.strikethrough)))
                        } else {
                            result.append(.char(char))
                            result.append(.char(currChar))
                        }
                    } else {
                        prevChar = currChar
                    }
                } else if currChar == "(" {
                    if let char = prevChar {
                        prevChar = nil
                        result.append(.char(char))
                    }
                    result.append(.control(.openBracket(.round)))
                } else if currChar == ")" {
                    if let char = prevChar {
                        prevChar = nil
                        result.append(.char(char))
                    }
                    result.append(.control(.closeBracket(.round)))
                } else if currChar == "[" {
                    if let char = prevChar {
                        prevChar = nil
                        result.append(.char(char))
                    }
                    result.append(.control(.openBracket(.square)))
                } else if currChar == "]" {
                    if let char = prevChar {
                        result.append(.char(char))
                    }
                    result.append(.control(.closeBracket(.square)))
                } else {
                    if let char = prevChar {
                        prevChar = nil
                        result.append(.char(char))
                    }
                    result.append(.char(currChar))
                }
            case .end:
                if let char = prevChar {
                    prevChar = nil
                    result.append(.char(char))
                }
                result.append(.char("\n"))
            }
        }
        return result
    }
    
    @inline(__always)
    static func _parts(
        _ tokens: [TextToken]
    ) -> [UI.Markdown.Text.Part] {
        var options = UI.Markdown.Text.Options()
        return Self._parts(
            tokens: tokens,
            options: &options
        )
    }
    
    @inline(__always)
    static func _parts< Tokens : RandomAccessCollection >(
        tokens: Tokens,
        options: inout UI.Markdown.Text.Options
    ) -> [UI.Markdown.Text.Part] where
        Tokens.Element == TextToken
    {
        var result: [UI.Markdown.Text.Part] = []
        var buffer = ""
        var index = tokens.startIndex
        while index < tokens.endIndex {
            let token = tokens[index]
            switch token {
            case .control(let control):
                switch control {
                case .simple(let simple):
                    index = tokens.index(index, offsetBy: 1)
                    if buffer.isEmpty == false {
                        result.append(.plain(options: options, text: buffer))
                        buffer.removeAll(keepingCapacity: true)
                    }
                    let textOptions = simple._textOptions
                    if options.contains(textOptions) == true {
                        options.remove(textOptions)
                    } else {
                        options.insert(textOptions)
                    }
                case .openBracket(let bracket):
                    switch bracket {
                    case .round:
                        buffer.append("(")
                        index = tokens.index(index, offsetBy: 1)
                    case .square:
                        if let range = Self._linkRanges(tokens: tokens, from: tokens.index(index, offsetBy: 1)) {
                            if buffer.isEmpty == false {
                                result.append(.plain(options: options, text: buffer))
                                buffer.removeAll(keepingCapacity: true)
                            }
                            let parts = Self._parts(
                                tokens: tokens[range.title],
                                options: &options
                            )
                            let url = Self._text(
                                tokens: tokens[range.url]
                            )
                            result.append(.link(
                                text: .init(parts),
                                url: URL(string: url)
                            ))
                            index = tokens.index(range.url.upperBound, offsetBy: 1)
                        } else {
                            buffer.append("[")
                            index = tokens.index(index, offsetBy: 1)
                        }
                    }
                case .closeBracket(let bracket):
                    switch bracket {
                    case .round:
                        buffer.append(")")
                        index = tokens.index(index, offsetBy: 1)
                    case .square:
                        buffer.append("]")
                        index = tokens.index(index, offsetBy: 1)
                    }
                }
            case .char(let char):
                buffer.append(char)
                index = tokens.index(index, offsetBy: 1)
            }
        }
        if buffer.isEmpty == false {
            result.append(.plain(options: options, text: buffer))
        }
        return result
    }
    
    @inline(__always)
    static func _linkRanges< Tokens : RandomAccessCollection >(
        tokens: Tokens,
        from: Tokens.Index
    ) -> (
        title: Range< Tokens.Index >,
        url: Range< Tokens.Index >
    )? where
        Tokens.Element == TextToken
    {
        var titleEnd: Tokens.Index?
        var urlStart: Tokens.Index?
        var index = from
        while index < tokens.endIndex {
            let token = tokens[index]
            switch token {
            case .control(let control):
                switch control {
                case .simple:
                    break
                case .openBracket(let bracket):
                    switch bracket {
                    case .round:
                        guard urlStart == nil else {
                            return nil
                        }
                        urlStart = tokens.index(index, offsetBy: 1)
                    case .square:
                        break
                    }
                case .closeBracket(let bracket):
                    switch bracket {
                    case .round:
                        guard let titleEnd = titleEnd, let urlStart = urlStart else {
                            return nil
                        }
                        guard from < titleEnd && urlStart < index else {
                            return nil
                        }
                        return (
                            title: from ..< titleEnd,
                            url: urlStart ..< index
                        )
                    case .square:
                        guard titleEnd == nil else {
                            return nil
                        }
                        titleEnd = index
                    }
                }
            case .char:
                break
            }
            index = tokens.index(index, offsetBy: 1)
        }
        return nil
    }
    
    @inline(__always)
    static func _text< Tokens : RandomAccessCollection >(
        tokens: Tokens
    ) -> String where
        Tokens.Element == TextToken
    {
        var result = ""
        for token in tokens {
            switch token {
            case .control(let control):
                switch control {
                case .simple(let simple):
                    switch simple {
                    case .italic: result.append("//")
                    case .bold: result.append("**")
                    case .underline: result.append("__")
                    case .strikethrough: result.append("--")
                    }
                case .openBracket(let bracket):
                    switch bracket {
                    case .round: result.append("(")
                    case .square: result.append("[")
                    }
                case .closeBracket(let bracket):
                    switch bracket {
                    case .round: result.append(")")
                    case .square: result.append("]")
                    }
                }
            case .char(let char):
                result.append(char)
            }
        }
        return result
    }

}

fileprivate extension UI.Markdown.Parser.Simple {
    
    var _textOptions: UI.Markdown.Text.Options {
        switch self {
        case .italic: return .italic
        case .bold: return .bold
        case .underline: return .underline
        case .strikethrough: return .strikethrough
        }
    }
    
}
