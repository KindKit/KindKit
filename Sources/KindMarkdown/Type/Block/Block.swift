//
//  KindKit
//

public enum Block : Equatable {
    
    case code(Block.Code)
    case heading(Block.Heading)
    case list(Block.List)
    case paragraph(Block.Paragraph)
    case quote(Block.Quote)
    
}

public extension Block {
    
    @inlinable
    static func code(
        level: UInt,
        content: Text
    ) -> Self {
        return .code(.init(level: level, content: content))
    }
    
    @inlinable
    static func heading(
        level: UInt,
        content: Text
    ) -> Self {
        return .heading(.init(level: level, content: content))
    }
    
    @inlinable
    static func list(
        marker: Text,
        content: Text
    ) -> Self {
        return .list(.init(marker: marker, content: content))
    }
    
    @inlinable
    static func paragraph(
        content: Text
    ) -> Self {
        return .paragraph(.init(content: content))
    }
    
    @inlinable
    static func quote(
        level: UInt,
        content: Text
    ) -> Self {
        return .quote(.init(level: level, content: content))
    }
    
}
