//
//  KindKit
//

import Foundation

public extension UI.Markdown.Text {
    
    indirect enum Part : Equatable {
        
        case plain(UI.Markdown.Text.Part.Plain)
        case link(UI.Markdown.Text.Part.Link)
        
    }
    
}

public extension UI.Markdown.Text.Part {
    
    @inlinable
    func attributedString(
        style: UI.Markdown.Style.Text,
        extra: [NSAttributedString.Key : Any]
    ) -> NSAttributedString {
        switch self {
        case .plain(let part): return part.attributedString(style: style.normal, extra: extra)
        case .link(let part): return part.attributedString(style: style.link, extra: extra)
        }
    }
    
    @inlinable
    func attributedString(
        style: UI.Markdown.Style.Text.Specific,
        extra: [NSAttributedString.Key : Any]
    ) -> NSAttributedString {
        switch self {
        case .plain(let part): return part.attributedString(style: style, extra: extra)
        case .link(let part): return part.attributedString(style: style, extra: extra)
        }
    }
    
}

public extension UI.Markdown.Text.Part {
    
    @inlinable
    static func plain(
        options: UI.Markdown.Text.Options = [],
        text: String
    ) -> Self {
        return .plain(.init(options: options, text: text))
    }
    
    @inlinable
    static func link(
        text: UI.Markdown.Text,
        url: URL?
    ) -> Self {
        return .link(.init(text: text, url: url))
    }
    
}
