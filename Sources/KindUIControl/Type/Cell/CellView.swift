//
//  KindKit
//

import KindTime
import KindUI

fileprivate enum Defaults {
    
    static let inset = Inset.zero
    
}

public final class CellView< BackgroundType : IView, ContentType : IView > : IComposite, IView {
    
    public let body: PressView< AnyLayout >
    
    public var background: BackgroundType {
        set { self._layout.substrate.content = newValue }
        get { self._layout.substrate.content }
    }
    
    public var content: ContentType {
        set { self._layout.content.content.content = newValue }
        get { self._layout.content.content.content }
    }
    
    public var inset: Inset {
        set { self._layout.content.inset = newValue }
        get { self._layout.content.inset }
    }
    
    private let _layout: SubstrateLayout<
        ViewLayout< BackgroundType >,
        MarginLayout< 
            ViewLayout< ContentType >
        >
    >
    
    public init(
        background: BackgroundType,
        content: ContentType
    ) {
        self._layout = SubstrateLayout(
            substrate: ViewLayout(background),
            content: MarginLayout(
                ViewLayout(content)
            ).update(on: {
                $0.inset = Defaults.inset
            })
        )
        
        self.body = .init(self._layout)
        
        self.body.onChange(self, { $0._onChange() })
    }
    
}

extension CellView : IViewSupportDynamicSize {
}

extension CellView : IViewSupportContent {
}

extension CellView : IViewSupportChange {
}

extension CellView : IViewSupportPress {
}

extension CellView : IViewSupportHighlighted {
}

extension CellView : IViewSupportSelected {
}

extension CellView : IViewSupportEnable {
}

extension CellView : IViewSupportAlpha {
}

extension CellView : IViewSupportInset {
}

extension CellView : IViewSupportBackground {
}

private extension CellView {

    func _onChange() {
        do {
            if let background = self.background as? IViewSupportHighlighted {
                background.isHighlighted = self.isHighlighted
            }
            if let background = self.background as? IViewSupportSelected {
                background.isSelected = self.isSelected
            }
        }
        do {
            if let content = self.content as? IViewSupportHighlighted {
                content.isHighlighted = self.isHighlighted
            }
            if let content = self.content as? IViewSupportSelected {
                content.isSelected = self.isSelected
            }
        }
    }
    
}
