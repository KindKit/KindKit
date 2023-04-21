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
    
    static func `default`(
        fontFamily: UI.Markdown.Style.Text.FontFamily = .system,
        fontSize: Double = UI.Font.systemSize,
        fontColor: UI.Color = .black,
        fontFirstLineIndent: Double? = nil,
        fontLineSpacing: Double? = nil,
        linkFontColor: UI.Color = .skyBlue
    ) -> Self {
        let normalText = UI.Markdown.Style.Text.Specific()
            .fontFamily(fontFamily)
            .fontSize(fontSize)
            .fontColor(fontColor)
            .firstLineIndent(fontFirstLineIndent)
            .lineSpacing(fontLineSpacing)
        
        let linkText = UI.Markdown.Style.Text.Specific(inherit: normalText)
            .fontColor(linkFontColor)
        
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
                        normal: .init(inherit: normalText).fontSize(fontSize * 2),
                        link: .init(inherit: linkText).fontSize(fontSize * 2)
                    )
                ),
                .init(
                    style: .init(),
                    content: .init(
                        normal: .init(inherit: normalText).fontSize(fontSize * 1.75),
                        link: .init(inherit: linkText).fontSize(fontSize * 1.75)
                    )
                ),
                .init(
                    style: .init(),
                    content: .init(
                        normal: .init(inherit: normalText).fontSize(fontSize * 1.5),
                        link: .init(inherit: linkText).fontSize(fontSize * 1.5)
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
