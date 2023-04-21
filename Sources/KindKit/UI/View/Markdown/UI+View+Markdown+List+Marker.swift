//
//  KindKit
//

import Foundation

extension UI.View.Markdown.List {

    final class Marker {
        
        let isFirst: Bool
        let isLast: Bool
        let style: UI.Markdown.Style.Block.List
        let content: UI.View.Markdown.Text
        let entity: UI.Layout.Composition.Margin

        init(
            isFirst: Bool,
            isLast: Bool,
            styleSheet: IUIMarkdownStyleSheet,
            block: UI.Markdown.Block.List,
            onOpenLink: Signal.Args< Void, URL >
        ) {
            self.isFirst = isFirst
            
            self.isLast = isLast
            
            self.style = styleSheet.listBlock(block)
            
            self.content = .init(
                style: styleSheet.listMarker(block),
                text: block.marker,
                onOpenLink: onOpenLink
            )
            
            self.entity = .init(
                inset: self.style.markerInset.trim(
                    top: self.isFirst,
                    bottom: self.isLast
                ),
                entity: self.content
            )
            
            self._setup()
        }
        
    }
    
}

private extension UI.View.Markdown.List.Marker {
    
    func _setup() {
        self.style.onChanged.subscribe(self, { $0._onChangedStyle() })
    }
    
    func _onChangedStyle() {
        self.entity.inset = self.style.markerInset.trim(
            top: self.isFirst,
            bottom: self.isLast
        )
    }
    
}

extension UI.View.Markdown.List.Marker : IUICompositionLayoutEntity {

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
