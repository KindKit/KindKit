//
//  KindKit
//

import KindGraphics
import KindMarkdown

public extension StyleSheet {
    
    final class Simple {
        
        public let code: [StyleSheet.Simple.Code]
        public let heading: [StyleSheet.Simple.Heading]
        public let list: StyleSheet.Simple.List
        public let quote: [StyleSheet.Simple.Quote]
        public let paragraph: StyleSheet.Simple.Paragraph
        
        public init(
            code: [StyleSheet.Simple.Code],
            heading: [StyleSheet.Simple.Heading],
            list: StyleSheet.Simple.List,
            quote: [StyleSheet.Simple.Quote],
            paragraph: StyleSheet.Simple.Paragraph
        ) {
            self.code = code
            self.heading = heading
            self.list = list
            self.quote = quote
            self.paragraph = paragraph
        }
        
    }
    
}

extension StyleSheet.Simple : IStyleSheet {
    
    public func codeBlock(_ block: Block.Code) -> Style.Block.Code {
        let index = min(Int(block.level), self.code.endIndex) - 1
        return self.code[index].style
    }
    
    public func codeContent(_ block: Block.Code) -> Style.Text {
        let index = min(Int(block.level), self.code.endIndex) - 1
        return self.code[index].content
    }
    
    public func headingBlock(_ block: Block.Heading) -> Style.Block.Heading {
        let index = min(Int(block.level), self.heading.endIndex) - 1
        return self.heading[index].style
    }
    
    public func headingContent(_ block: Block.Heading) -> Style.Text {
        let index = min(Int(block.level), self.heading.endIndex) - 1
        return self.heading[index].content
    }
    
    public func listBlock(_ block: Block.List) -> Style.Block.List {
        return self.list.style
    }
    
    public func listMarker(_ block: Block.List) -> Style.Text {
        return self.list.marker
    }
    
    public func listContent(_ block: Block.List) -> Style.Text {
        return self.list.content
    }
    
    public func quoteBlock(_ block: Block.Quote) -> Style.Block.Quote {
        let index = min(Int(block.level), self.quote.endIndex) - 1
        return self.quote[index].style
    }
    
    public func quoteContent(_ block: Block.Quote) -> Style.Text {
        let index = min(Int(block.level), self.quote.endIndex) - 1
        return self.quote[index].content
    }
    
    public func paragraphBlock(_ block: Block.Paragraph) -> Style.Block.Paragraph {
        return self.paragraph.style
    }
    
    public func paragraphContent(_ block: Block.Paragraph) -> Style.Text {
        return self.paragraph.content
    }
    
}

public extension IStyleSheet where Self == StyleSheet.Simple {
    
    @inlinable
    static func `default`(
        normalFontFamily: Style.Text.FontFamily = .system,
        normalFontWeight: Style.Text.FontWeight? = nil,
        normalFontSize: Double = Font.systemSize,
        normalFontColor: Color = .black,
        normalStrokeWidth: Double? = nil,
        normalStrokeColor: Color? = nil,
        normalUnderlineStyle: KindGraphics.Text.Underline? = nil,
        normalUnderlineColor: Color? = nil,
        normalStrikethroughStyle: KindGraphics.Text.Strikethrough? = nil,
        normalStrikethroughColor: Color? = nil,
        normalLigatures: Bool? = nil,
        normalKerning: Double? = nil,
        normalFirstLineIndent: Double? = nil,
        normalLineSpacing: Double? = nil,
        normalMinimumLineHeight: Double? = nil,
        normalMaximumLineHeight: Double? = nil,
        normalLineHeightMultiple: Double? = nil,
        normalAlignment: KindGraphics.Text.Alignment? = nil,
        normalLineBreak: KindGraphics.Text.LineBreak? = nil,
        normalBaseWritingDirection: KindGraphics.Text.WritingDirection? = nil,
        normalHyphenationFactor: Float? = nil,
        linkFontFamily: Style.Text.FontFamily? = nil,
        linkFontWeight: Style.Text.FontWeight? = nil,
        linkFontSize: Double? = nil,
        linkFontColor: Color = .skyBlue,
        linkStrokeWidth: Double? = nil,
        linkStrokeColor: Color? = nil,
        linkUnderlineStyle: KindGraphics.Text.Underline? = nil,
        linkUnderlineColor: Color? = nil,
        linkStrikethroughStyle: KindGraphics.Text.Strikethrough? = nil,
        linkStrikethroughColor: Color? = nil,
        linkLigatures: Bool? = nil,
        linkKerning: Double? = nil,
        linkFirstLineIndent: Double? = nil,
        linkLineSpacing: Double? = nil,
        linkMinimumLineHeight: Double? = nil,
        linkMaximumLineHeight: Double? = nil,
        linkLineHeightMultiple: Double? = nil,
        linkAlignment: KindGraphics.Text.Alignment? = nil,
        linkLineBreak: KindGraphics.Text.LineBreak? = nil,
        linkBaseWritingDirection: KindGraphics.Text.WritingDirection? = nil,
        linkHyphenationFactor: Float? = nil
    ) -> Self {
        let normalText = Style.Text.Specific()
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
        
        let linkText = Style.Text.Specific(inherit: normalText)
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
        normalText: Style.Text.Specific,
        linkText: Style.Text.Specific
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
