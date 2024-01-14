//
//  KindKit
//

import KindMarkdown

public protocol IStyleSheet : AnyObject {
    
    func codeBlock(_ block: Block.Code) -> Style.Block.Code
    func codeContent(_ block: Block.Code) -> Style.Text
    
    func headingBlock(_ block: Block.Heading) -> Style.Block.Heading
    func headingContent(_ block: Block.Heading) -> Style.Text
    
    func listBlock(_ block: Block.List) -> Style.Block.List
    func listMarker(_ block: Block.List) -> Style.Text
    func listContent(_ block: Block.List) -> Style.Text
    
    func quoteBlock(_ block: Block.Quote) -> Style.Block.Quote
    func quoteContent(_ block: Block.Quote) -> Style.Text
    
    func paragraphBlock(_ block: Block.Paragraph) -> Style.Block.Paragraph
    func paragraphContent(_ block: Block.Paragraph) -> Style.Text

}
