//
//  KindKit
//

import Foundation

public extension UI.Markdown {
    
    struct Text : Equatable {
        
        public let parts: [UI.Markdown.Text.Part]
        
        public init(
            _ parts: [UI.Markdown.Text.Part] = []
        ) {
            self.parts = parts
        }
        
    }
    
}

public extension UI.Markdown.Text {
    
    @inlinable
    func attributedString(
        style: UI.Markdown.Style.Text,
        extra: [NSAttributedString.Key : Any] = [:]
    ) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.beginEditing()
        for part in self.parts {
            result.append(part.attributedString(style: style, extra: extra))
        }
        result.endEditing()
        return result
    }
    
    @inlinable
    func attributedString(
        style: UI.Markdown.Style.Text.Specific,
        extra: [NSAttributedString.Key : Any] = [:]
    ) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.beginEditing()
        for part in self.parts {
            result.append(part.attributedString(style: style, extra: extra))
        }
        result.endEditing()
        return result
    }
    
}

public extension UI.Markdown.Text {
    
    @inlinable
    static func text(
        _ parts: [UI.Markdown.Text.Part] = []
    ) -> Self {
        return .init(parts)
    }
    
}
