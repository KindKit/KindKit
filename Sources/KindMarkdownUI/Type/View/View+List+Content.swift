//
//  KindKit
//

import KindMarkdown
import KindUI

extension View.List {

    final class Content {
        
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
                style: styleSheet.listContent(block),
                text: block.content,
                width: .fill,
                onOpenLink: onOpenLink
            )
            
            self.entity = .init(
                inset: self.style.contentInset.trim(
                    top: self.isFirst,
                    bottom: self.isLast
                ),
                content: self.content
            )
            
            self._setup()
        }
        
    }
    
}

private extension View.List.Content {
    
    func _setup() {
        self.style.onChanged.add(self, { $0._onChangedStyle() })
    }
    
    func _onChangedStyle() {
        self.entity.inset = self.style.contentInset.trim(
            top: self.isFirst,
            bottom: self.isLast
        )
    }
    
}

extension View.List.Content : ILayout {

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
