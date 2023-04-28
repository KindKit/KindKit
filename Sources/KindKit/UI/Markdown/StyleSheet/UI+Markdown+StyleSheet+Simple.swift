//
//  KindKit
//

import Foundation

public extension UI.Markdown.StyleSheet {
    
    final class Simple {
        
        public let code: [UI.Markdown.StyleSheet.Simple.Code]
        public let heading: [UI.Markdown.StyleSheet.Simple.Heading]
        public let list: UI.Markdown.StyleSheet.Simple.List
        public let quote: [UI.Markdown.StyleSheet.Simple.Quote]
        public let paragraph: UI.Markdown.StyleSheet.Simple.Paragraph
        
        public init(
            code: [UI.Markdown.StyleSheet.Simple.Code],
            heading: [UI.Markdown.StyleSheet.Simple.Heading],
            list: UI.Markdown.StyleSheet.Simple.List,
            quote: [UI.Markdown.StyleSheet.Simple.Quote],
            paragraph: UI.Markdown.StyleSheet.Simple.Paragraph
        ) {
            self.code = code
            self.heading = heading
            self.list = list
            self.quote = quote
            self.paragraph = paragraph
        }
        
    }
    
}

extension UI.Markdown.StyleSheet.Simple : IUIMarkdownStyleSheet {
    
    public func codeBlock(_ block: UI.Markdown.Block.Code) -> UI.Markdown.Style.Block.Code {
        let index = min(Int(block.level), self.code.endIndex) - 1
        return self.code[index].style
    }
    
    public func codeContent(_ block: UI.Markdown.Block.Code) -> UI.Markdown.Style.Text {
        let index = min(Int(block.level), self.code.endIndex) - 1
        return self.code[index].content
    }
    
    public func headingBlock(_ block: UI.Markdown.Block.Heading) -> UI.Markdown.Style.Block.Heading {
        let index = min(Int(block.level), self.heading.endIndex) - 1
        return self.heading[index].style
    }
    
    public func headingContent(_ block: UI.Markdown.Block.Heading) -> UI.Markdown.Style.Text {
        let index = min(Int(block.level), self.heading.endIndex) - 1
        return self.heading[index].content
    }
    
    public func listBlock(_ block: UI.Markdown.Block.List) -> UI.Markdown.Style.Block.List {
        return self.list.style
    }
    
    public func listMarker(_ block: UI.Markdown.Block.List) -> UI.Markdown.Style.Text {
        return self.list.marker
    }
    
    public func listContent(_ block: UI.Markdown.Block.List) -> UI.Markdown.Style.Text {
        return self.list.content
    }
    
    public func quoteBlock(_ block: UI.Markdown.Block.Quote) -> UI.Markdown.Style.Block.Quote {
        let index = min(Int(block.level), self.quote.endIndex) - 1
        return self.quote[index].style
    }
    
    public func quoteContent(_ block: UI.Markdown.Block.Quote) -> UI.Markdown.Style.Text {
        let index = min(Int(block.level), self.quote.endIndex) - 1
        return self.quote[index].content
    }
    
    public func paragraphBlock(_ block: UI.Markdown.Block.Paragraph) -> UI.Markdown.Style.Block.Paragraph {
        return self.paragraph.style
    }
    
    public func paragraphContent(_ block: UI.Markdown.Block.Paragraph) -> UI.Markdown.Style.Text {
        return self.paragraph.content
    }
    
}

public extension IUIMarkdownStyleSheet where Self == UI.Markdown.StyleSheet.Simple {
    
    @inlinable
    static func `default`(
        normalFontFamily: UI.Markdown.Style.Text.FontFamily = .system,
        normalFontWeight: UI.Markdown.Style.Text.FontWeight? = nil,
        normalFontSize: Double = UI.Font.systemSize,
        normalFontColor: UI.Color = .black,
        normalStrokeWidth: Double? = nil,
        normalStrokeColor: UI.Color? = nil,
        normalUnderlineStyle: UI.Text.Underline? = nil,
        normalUnderlineColor: UI.Color? = nil,
        normalStrikethroughStyle: UI.Text.Strikethrough? = nil,
        normalStrikethroughColor: UI.Color? = nil,
        normalLigatures: Bool? = nil,
        normalKerning: Double? = nil,
        normalFirstLineIndent: Double? = nil,
        normalLineSpacing: Double? = nil,
        normalMinimumLineHeight: Double? = nil,
        normalMaximumLineHeight: Double? = nil,
        normalLineHeightMultiple: Double? = nil,
        normalAlignment: UI.Text.Alignment? = nil,
        normalLineBreak: UI.Text.LineBreak? = nil,
        normalBaseWritingDirection: UI.Text.WritingDirection? = nil,
        normalHyphenationFactor: Float? = nil,
        linkFontFamily: UI.Markdown.Style.Text.FontFamily? = nil,
        linkFontWeight: UI.Markdown.Style.Text.FontWeight? = nil,
        linkFontSize: Double? = nil,
        linkFontColor: UI.Color = .skyBlue,
        linkStrokeWidth: Double? = nil,
        linkStrokeColor: UI.Color? = nil,
        linkUnderlineStyle: UI.Text.Underline? = nil,
        linkUnderlineColor: UI.Color? = nil,
        linkStrikethroughStyle: UI.Text.Strikethrough? = nil,
        linkStrikethroughColor: UI.Color? = nil,
        linkLigatures: Bool? = nil,
        linkKerning: Double? = nil,
        linkFirstLineIndent: Double? = nil,
        linkLineSpacing: Double? = nil,
        linkMinimumLineHeight: Double? = nil,
        linkMaximumLineHeight: Double? = nil,
        linkLineHeightMultiple: Double? = nil,
        linkAlignment: UI.Text.Alignment? = nil,
        linkLineBreak: UI.Text.LineBreak? = nil,
        linkBaseWritingDirection: UI.Text.WritingDirection? = nil,
        linkHyphenationFactor: Float? = nil
    ) -> Self {
        let normalText = UI.Markdown.Style.Text.Specific()
            .fontFamily(normalFontFamily)
            .fontWeight(normalFontWeight)
            .fontSize(normalFontSize)
            .fontColor(normalFontColor)
            .strokeWidth(normalStrokeWidth)
            .strokeColor(normalStrokeColor)
            .underlineStyle(normalUnderlineStyle)
            .underlineColor(normalUnderlineColor)
            .strikethroughStyle(normalStrikethroughStyle)
            .strikethroughColor(normalStrikethroughColor)
            .ligatures(normalLigatures)
            .kerning(normalKerning)
            .firstLineIndent(normalFirstLineIndent)
            .lineSpacing(normalLineSpacing)
            .minimumLineHeight(normalMinimumLineHeight)
            .maximumLineHeight(normalMaximumLineHeight)
            .lineHeightMultiple(normalLineHeightMultiple)
            .alignment(normalAlignment)
            .lineBreak(normalLineBreak)
            .baseWritingDirection(normalBaseWritingDirection)
            .hyphenationFactor(normalHyphenationFactor)
        
        let linkText = UI.Markdown.Style.Text.Specific(inherit: normalText)
            .fontFamily(linkFontFamily)
            .fontWeight(linkFontWeight)
            .fontSize(linkFontSize)
            .fontColor(linkFontColor)
            .strokeWidth(linkStrokeWidth)
            .strokeColor(linkStrokeColor)
            .underlineStyle(linkUnderlineStyle)
            .underlineColor(linkUnderlineColor)
            .strikethroughStyle(linkStrikethroughStyle)
            .strikethroughColor(linkStrikethroughColor)
            .ligatures(linkLigatures)
            .kerning(linkKerning)
            .firstLineIndent(linkFirstLineIndent)
            .lineSpacing(linkLineSpacing)
            .minimumLineHeight(linkMinimumLineHeight)
            .maximumLineHeight(linkMaximumLineHeight)
            .lineHeightMultiple(linkLineHeightMultiple)
            .alignment(linkAlignment)
            .lineBreak(linkLineBreak)
            .baseWritingDirection(linkBaseWritingDirection)
            .hyphenationFactor(linkHyphenationFactor)
        
        return Self.default(
            normalText: normalText,
            linkText: linkText
        )
    }
    
    @inlinable
    static func `default`(
        normalText: UI.Markdown.Style.Text.Specific,
        linkText: UI.Markdown.Style.Text.Specific
    ) -> Self {
        return .init(
            code: [
                .init(
                    style: .init(),
                    content: .init(
                        normal: normalText,
                        link: linkText
                    )
                )
            ],
            heading: [
                .init(
                    style: .init(),
                    content: .init(
                        normal: .init(inherit: normalText).fontSizeMultiple(2),
                        link: .init(inherit: linkText).fontSizeMultiple(2)
                    )
                ),
                .init(
                    style: .init(),
                    content: .init(
                        normal: .init(inherit: normalText).fontSizeMultiple(1.75),
                        link: .init(inherit: linkText).fontSizeMultiple(1.75)
                    )
                ),
                .init(
                    style: .init(),
                    content: .init(
                        normal: .init(inherit: normalText).fontSizeMultiple(1.5),
                        link: .init(inherit: linkText).fontSizeMultiple(1.5)
                    )
                )
            ],
            list: .init(
                style: .init(),
                marker: .init(
                    normal: normalText,
                    link: linkText
                ),
                content: .init(
                    normal: normalText,
                    link: linkText
                )
            ),
            quote: [
                .init(
                    style: .init(),
                    content: .init(
                        normal: normalText,
                        link: linkText
                    )
                )
            ],
            paragraph: .init(
                style: .init(),
                content: .init(
                    normal: normalText,
                    link: linkText
                )
            )
        )
    }
    
}
