//
//  KindKit
//

import Foundation

public extension UI.Markdown {
    
    enum Block : Equatable {
        
        case code(UI.Markdown.Block.Code)
        case heading(UI.Markdown.Block.Heading)
        case list(UI.Markdown.Block.List)
        case paragraph(UI.Markdown.Block.Paragraph)
        case quote(UI.Markdown.Block.Quote)
        
    }
    
}

public extension UI.Markdown.Block {
    
    @inlinable
    static func code(
        level: UInt,
        content: UI.Markdown.Text
    ) -> Self {
        return .code(.init(level: level, content: content))
    }
    
    @inlinable
    static func heading(
        level: UInt,
        content: UI.Markdown.Text
    ) -> Self {
        return .heading(.init(level: level, content: content))
    }
    
    @inlinable
    static func list(
        marker: UI.Markdown.Text,
        content: UI.Markdown.Text
    ) -> Self {
        return .list(.init(marker: marker, content: content))
    }
    
    @inlinable
    static func paragraph(
        content: UI.Markdown.Text
    ) -> Self {
        return .paragraph(.init(content: content))
    }
    
    @inlinable
    static func quote(
        level: UInt,
        content: UI.Markdown.Text
    ) -> Self {
        return .quote(.init(level: level, content: content))
    }
    
}
