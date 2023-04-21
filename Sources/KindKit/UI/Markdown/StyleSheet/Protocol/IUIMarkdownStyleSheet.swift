//
//  KindKit
//

import Foundation

public protocol IUIMarkdownStyleSheet : AnyObject {
    
    func codeBlock(_ block: UI.Markdown.Block.Code) -> UI.Markdown.Style.Block.Code
    func codeContent(_ block: UI.Markdown.Block.Code) -> UI.Markdown.Style.Text
    
    func headingBlock(_ block: UI.Markdown.Block.Heading) -> UI.Markdown.Style.Block.Heading
    func headingContent(_ block: UI.Markdown.Block.Heading) -> UI.Markdown.Style.Text
    
    func listBlock(_ block: UI.Markdown.Block.List) -> UI.Markdown.Style.Block.List
    func listMarker(_ block: UI.Markdown.Block.List) -> UI.Markdown.Style.Text
    func listContent(_ block: UI.Markdown.Block.List) -> UI.Markdown.Style.Text
    
    func quoteBlock(_ block: UI.Markdown.Block.Quote) -> UI.Markdown.Style.Block.Quote
    func quoteContent(_ block: UI.Markdown.Block.Quote) -> UI.Markdown.Style.Text
    
    func paragraphBlock(_ block: UI.Markdown.Block.Paragraph) -> UI.Markdown.Style.Block.Paragraph
    func paragraphContent(_ block: UI.Markdown.Block.Paragraph) -> UI.Markdown.Style.Text

}
