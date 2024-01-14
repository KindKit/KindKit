//
//  KindKit
//

import KindMarkdown
import KindUI

extension View {

    final class Text {
        
        let style: Style.Text
        let text: KindMarkdown.Text
        let onOpenLink: Signal< Void, URL >
        let view: AttributedTextView
        let entity: CompositionLayout.ViewPart
        
        init(
            style: Style.Text,
            text: KindMarkdown.Text,
            width: DynamicSize.Dimension,
            onOpenLink: Signal< Void, URL >
        ) {
            self.style = style
            
            self.text = text
            
            self.onOpenLink = onOpenLink
            
            self.view = .init()
                .width(width)
                .text(text.attributedString(style: style))
            
            self.entity = .init(self.view)
            
            self._setup()
        }
        
    }
    
}

private extension View.Text {
    
    func _setup() {
        self.style.onChanged.add(self, { $0._onChangedStyle() })
        self.view.onTap(self, { $0._onTap($1) })
    }
    
    func _onChangedStyle() {
        self.view.text = self.text.attributedString(style: self.style)
    }
    
    func _onTap(_ attributes: [NSAttributedString.Key : Any]? ) {
        guard let url = attributes?[.kk_customLink] as? URL else { return }
        self.onOpenLink.emit(url)
    }
    
}

extension View.Text : ILayoutPart {

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

