//
//  KindKit
//

import KindTime
import KindUI
import KindMonadicMacro

fileprivate enum Defaults {
    
    static let inset = Inset(horizontal: 8, vertical: 2)
    
}

@KindMonadic
public final class BadgeView< BackgroundType : IView, ContentType : IView > : IComposite, IView {
    
    public let body: LayoutView< AnyLayout >
    
    @KindMonadicProperty(default: EmptyView.self)
    public var background: BackgroundType {
        set { self._layout.substrate.content = newValue }
        get { self._layout.substrate.content }
    }
    
    @KindMonadicProperty(default: EmptyView.self)
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
    }
    
}

extension BadgeView : IViewSupportDynamicSize {
}

extension BadgeView : IViewSupportContent {
}

extension BadgeView : IViewSupportAlpha {
}

extension BadgeView : IViewSupportInset {
}

extension BadgeView : IViewSupportBackground {
}
