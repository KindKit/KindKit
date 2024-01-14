//
//  KindKit
//

import KindMarkdown
import KindUI

extension View.List {

    final class Marker {
        
        let isFirst: Bool
        let isLast: Bool
        let style: Style.Block.List
        let content: View.Text
        let entity: CompositionLayout.MarginPart

        init(
            isFirst: Bool,
            isLast: Bool,
            styleSheet: IStyleSheet,
            block: Block.List,
            onOpenLink: Signal< Void, URL >
        ) {
            self.isFirst = isFirst
            
            self.isLast = isLast
            
            self.style = styleSheet.listBlock(block)
            
            self.content = .init(
                style: styleSheet.listMarker(block),
                text: block.marker,
                width: .fit,
                onOpenLink: onOpenLink
            )
            
            self.entity = .init(
                inset: self.style.markerInset.trim(
                    top: self.isFirst,
                    bottom: self.isLast
                ),
                content: self.content
            )
            
            self._setup()
        }
        
    }
    
}

private extension View.List.Marker {
    
    func _setup() {
        self.style.onChanged.add(self, { $0._onChangedStyle() })
    }
    
    func _onChangedStyle() {
        self.entity.inset = self.style.markerInset.trim(
            top: self.isFirst,
            bottom: self.isLast
        )
    }
    
}

extension View.List.Marker : ILayoutPart {

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
