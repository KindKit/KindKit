//
//  KindKit
//

import Foundation

public extension UI.Markdown {
    
    enum Parser {
    }
    
}

extension UI.Markdown.Parser {
    
    @inlinable
    static func tokens(
        _ string: String
    ) -> [UI.Markdown.Parser.Token] {
        let string = string
            .replacingOccurrences(of: "\\t", with: "\t")
            .replacingOccurrences(of: "\\r", with: "\r")
            .replacingOccurrences(of: "\\n", with: "\n")
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
        var result: [UI.Markdown.Parser.Token] = []
        var buffer: [UI.Markdown.Parser.Token] = []
        var isNewline: Bool = true
        var prevChar: Character? = nil
        for index in string.indices {
            let currChar = string[index]
            if currChar == "\t" {
                buffer.append(.tab)
            } else if currChar == " " {
                buffer.append(.space)
            } else if currChar == "\n" {
                buffer.removeAll(keepingCapacity: true)
                if result.isEmpty == false && result.last != .start {
                    result.append(.end)
                }
                isNewline = true
            } else {
                if isNewline == false {
                    if buffer.isEmpty == false {
                        for token in buffer {
                            result.append(token)
                        }
                        buffer.removeAll(keepingCapacity: true)
                    }
                } else {
                    result.append(.start)
                    buffer.removeAll(keepingCapacity: true)
                }
                isNewline = false
                if currChar == "\\" {
                    if prevChar == "\\" {
                        result.append(.raw(currChar))
                    }
                } else {
                    if prevChar == "\\" {
                        result.append(.escape(currChar))
                    } else {
                        result.append(.raw(currChar))
                    }
                }
            }
            prevChar = currChar
        }
        return result
    }
    
}
