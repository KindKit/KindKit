//
//  KindKit
//

import KindMarkdown
import KindUI

extension View {

    final class Quote {
        
        let isFirst: Bool
        let isLast: Bool
        let style: Style.Block.Quote
        let panel: KindUI.RectView
        let content: Text
        let entityContentMargin: CompositionLayout.MarginPart
        let entityContent: CompositionLayout.HAccessoryPart
        let entity: CompositionLayout.MarginPart

        init(
            isFirst: Bool,
            isLast: Bool,
            styleSheet: IStyleSheet,
            block: Block.Quote,
            onOpenLink: Signal< Void, URL >
        ) {
            self.isFirst = isFirst
            
            self.isLast = isLast
            
            self.style = styleSheet.quoteBlock(block)
            
            self.panel = .init()
                .width(.fixed(self.style.panelSize))
                .cornerRadius(self.style.panelCornerRadius)
                .border(self.style.panelBorder)
                .fill(self.style.panelColor)
            
            self.content = .init(
                style: styleSheet.quoteContent(block),
                text: block.content,
                width: .fill,
                onOpenLink: onOpenLink
            )
            
            self.entityContentMargin = .init(
                inset: self.style.contentInset,
                content: self.content
            )
            
            self.entityContent = .init(
                leading: CompositionLayout.ViewPart(self.panel),
                center: self.entityContentMargin
            )
            
            self.entity = .init(
                inset: self.style.inset.trim(
                    top: self.isFirst,
                    bottom: self.isLast
                ),
                content: self.entityContent
            )
            
            self._setup()
        }
        
    }
    
}

private extension View.Quote {
    
    func _setup() {
        self.style.onChanged.add(self, { $0._onChangedStyle() })
    }
    
    func _onChangedStyle() {
        self.panel.width = .fixed(self.style.panelSize)
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

extension View.Quote : ILayoutPart {

    func invalidate() {
        self.entity.invalidate()
    }
    
    func invalidate(_ view: IView) {
        self.entity.invalidate(view)
    }
    
    func layout(bounds: Rect) -> Size {
        return self.entity.layout(bounds: bounds)
    }
    
    func size(available: Size) -> Size {
        return self.entity.size(available: available)
    }
    
    func views(bounds: Rect) -> [IView] {
        return self.entity.views(bounds: bounds)
    }
    
}
