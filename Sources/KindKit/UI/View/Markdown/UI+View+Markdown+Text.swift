//
//  KindKit
//

import Foundation

extension UI.View.Markdown {

    final class Text {
        
        let style: UI.Markdown.Style.Text
        let text: UI.Markdown.Text
        let onOpenLink: Signal.Args< Void, URL >
        let view: UI.View.AttributedText
        let entity: UI.Layout.Composition.View
        
        init(
            style: UI.Markdown.Style.Text,
            text: UI.Markdown.Text,
            onOpenLink: Signal.Args< Void, URL >
        ) {
            self.style = style
            
            self.text = text
            
            self.onOpenLink = onOpenLink
            
            self.view = .init()
                .text(text.attributedString(style: style))
            
            self.entity = .init(self.view)
            
            self._setup()
        }
        
    }
    
}

private extension UI.View.Markdown.Text {
    
    func _setup() {
        self.style.onChanged.subscribe(self, { $0._onChangedStyle() })
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

extension UI.View.Markdown.Text : IUICompositionLayoutEntity {

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

