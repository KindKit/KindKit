//
//  KindKit
//

import KindUI
import KindMonadicMacro

@KindMonadic
public final class BarView< BackgroundType : IView, ContentType : IView, SeparatorType : IView > : IComposite, IView {
    
    public let body: LayoutView< AnyLayout >
    
    public var placement: Placement = .top {
        didSet {
            guard self.placement != oldValue else { return }
            switch self.placement {
            case .top:
                self._layout.update(on: {
                    $0.contentAnchor = .init(x: .half, y: .one)
                    $0.overlayAnchor = .init(x: .half, y: .zero)
                })
            case .bottom:
                self._layout.update(on: {
                    $0.contentAnchor = .init(x: .half, y: .zero)
                    $0.overlayAnchor = .init(x: .half, y: .one)
                })
            }
        }
    }
    
    public var inset: Inset {
        set { self._layout.content.content.inset = newValue }
        get { self._layout.content.content.inset }
    }
    
    @KindMonadicProperty(default: EmptyView.self)
    public var background: BackgroundType {
        set { self._layout.content.substrate.content = newValue }
        get { self._layout.content.substrate.content }
    }
    
    @KindMonadicProperty(default: EmptyView.self)
    public var content: ContentType {
        set { self._layout.content.content.content.content = newValue }
        get { self._layout.content.content.content.content }
    }
    
    @KindMonadicProperty(default: EmptyView.self)
    public var separator: SeparatorType {
        set { self._layout.overlay.content = newValue }
        get { self._layout.overlay.content }
    }
    
    private let _layout: AnchorLayout<
        SubstrateLayout<
            ViewLayout< BackgroundType >,
            MarginLayout< ViewLayout< ContentType > >
        >,
        ViewLayout< SeparatorType >
    >

    public init(
        background: BackgroundType,
        content: ContentType,
        separator: SeparatorType
    ) {
        self._layout = AnchorLayout(
            content: SubstrateLayout(
                substrate: ViewLayout(background),
                content: MarginLayout(
                    ViewLayout(content)
                )
            ),
            overlay: ViewLayout(separator)
        ).update(on: {
            $0.contentAnchor = .init(x: .half, y: .one)
            $0.overlayAnchor = .init(x: .half, y: .zero)
        })
        
        self.body = .init(self._layout)
            .clipsToBounds(false)
    }
    
}

extension BarView : IViewSupportDynamicSize {
}

extension BarView : IViewSupportContent {
}

extension BarView : IViewSupportAlpha {
}

extension BarView : IViewSupportEnable where ContentType : IViewSupportEnable {
    
    public var isEnabled: Bool {
        set { self.content.isEnabled = newValue }
        get { self.content.isEnabled }
    }
    
}

extension BarView : IViewSupportColor where BackgroundType : IViewSupportColor {
    
    public var color: Color {
        set { self.background.color = newValue }
        get { self.background.color }
    }
    
}

extension BarView : IViewSupportPlacement {
}

extension BarView : IViewSupportInset {
}

extension BarView : IViewSupportBackground {
}

extension BarView : IViewSupportSeparator {
}
