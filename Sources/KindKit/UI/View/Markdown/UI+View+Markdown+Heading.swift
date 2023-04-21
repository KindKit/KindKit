//
//  KindKit
//

import Foundation

extension UI.View.Markdown {

    final class Heading {
        
        let isFirst: Bool
        let isLast: Bool
        let style: UI.Markdown.Style.Block.Heading
        let content: UI.View.Markdown.Text
        let entity: UI.Layout.Composition.Margin

        init(
            isFirst: Bool,
            isLast: Bool,
            styleSheet: IUIMarkdownStyleSheet,
            block: UI.Markdown.Block.Heading,
            onOpenLink: Signal.Args< Void, URL >
        ) {
            self.isFirst = isFirst
            
            self.isLast = isLast
            
            self.style = styleSheet.headingBlock(block)
            
            self.content = .init(
                style: styleSheet.headingContent(block),
                text: block.content,
                onOpenLink: onOpenLink
            )
            
            self.entity = .init(
                inset: self.style.inset.trim(
                    top: self.isFirst,
                    bottom: self.isLast
                ),
                entity: self.content
            )
            
            self._setup()
        }
        
    }
    
}

private extension UI.View.Markdown.Heading {
    
    func _setup() {
        self.style.onChanged.subscribe(self, { $0._onChangedStyle() })
    }
    
    func _onChangedStyle() {
        self.entity.inset = self.style.inset.trim(
            top: self.isFirst,
            bottom: self.isLast
        )
    }
    
}

extension UI.View.Markdown.Heading : IUICompositionLayoutEntity {

    func invalidate() {
        self.entity.invalidate()
    }
    
    func invalidate(_ view: IUIView) {
        self.entity.invalidate(view)
    }
    
    func layout(bounds: Rect) -> Size {
        return self.entity.layout(bounds: bounds)
    }
    
    func size(available: Size) -> Size {
        return self.entity.size(available: available)
    }
    
    func views(bounds: Rect) -> [IUIView] {
        return self.entity.views(bounds: bounds)
    }
    
}
