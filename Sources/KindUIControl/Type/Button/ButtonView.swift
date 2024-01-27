//
//  KindKit
//

import KindTime
import KindUI

fileprivate enum Defaults {
    
    static let inset = Inset(horizontal: 4, vertical: 4)
    
}

public final class ButtonView< BackgroundType : IView, ContentType : IView > : IComposite, IView {
    
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

extension ButtonView : IViewSupportDynamicSize {
}

extension ButtonView : IViewSupportContent {
}

extension ButtonView : IViewSupportChange {
}

extension ButtonView : IViewSupportPress {
}

extension ButtonView : IViewSupportHighlighted {
}

extension ButtonView : IViewSupportSelected {
}

extension ButtonView : IViewSupportEnable {
}

extension ButtonView : IViewSupportAlpha {
}

extension ButtonView : IViewSupportInset {
}

extension ButtonView : IViewSupportBackground {
}

private extension ButtonView {

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
