//
//  KindKit
//

import Foundation

extension UI.View.Markdown {

    final class Quote {
        
        let isFirst: Bool
        let isLast: Bool
        let style: UI.Markdown.Style.Block.Quote
        let panel: UI.View.Rect
        let content: UI.View.Markdown.Text
        let entityContentMargin: UI.Layout.Composition.Margin
        let entityContent: UI.Layout.Composition.HAccessory
        let entity: UI.Layout.Composition.Margin

        init(
            isFirst: Bool,
            isLast: Bool,
            styleSheet: IUIMarkdownStyleSheet,
            block: UI.Markdown.Block.Quote,
            onOpenLink: Signal.Args< Void, URL >
        ) {
            self.isFirst = isFirst
            
            self.isLast = isLast
            
            self.style = styleSheet.quoteBlock(block)
            
            self.panel = .init()
                .cornerRadius(self.style.panelCornerRadius)
                .border(self.style.panelBorder)
                .fill(self.style.panelColor)
            
            self.content = .init(
                style: styleSheet.quoteContent(block),
                text: block.content,
                onOpenLink: onOpenLink
            )
            
            self.entityContentMargin = .init(
                inset: self.style.contentInset,
                entity: self.content
            )
            
            self.entityContent = .init(
                leading: .view(self.panel),
                center: self.entityContentMargin
            )
            
            self.entity = .init(
                inset: self.style.inset.trim(
                    top: self.isFirst,
                    bottom: self.isLast
                ),
                entity: self.entityContent
            )
            
            self._setup()
        }
        
    }
    
}

private extension UI.View.Markdown.Quote {
    
    func _setup() {
        self.style.onChanged.subscribe(self, { $0._onChangedStyle() })
    }
    
    func _onChangedStyle() {
        self.panel.cornerRadius = self.style.panelCornerRadius
        self.panel.border = self.style.panelBorder
        self.panel.fill = self.style.panelColor
        self.entityContentMargin.inset = self.style.contentInset
        self.entity.inset = self.style.inset.trim(
            top: self.isFirst,
            bottom: self.isLast
        )
    }
    
}

extension UI.View.Markdown.Quote : IUICompositionLayoutEntity {

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
