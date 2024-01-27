//
//  KindKit
//

import KindLayout
import KindMonadicMacro

@Monadic
public final class BarView< Background : IView, Content : IView, Separator : IView > : CompositorTrait, IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportContentInset, IViewSupportPlacement, IViewSupportAlpha, IViewContainBackground, IViewContainSeparator {
    
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
    
    public var contentInset: Inset {
        set { self._layout.content.content.inset = newValue }
        get { self._layout.content.content.inset }
    }
    
    @MonadicField(default: EmptyView.self)
    public var background: Background {
        set { self._layout.content.substrate.content = newValue }
        get { self._layout.content.substrate.content }
    }
    
    @MonadicField(default: EmptyView.self)
    public var content: Content {
        set { self._layout.content.content.content.content = newValue }
        get { self._layout.content.content.content.content }
    }
    
    @MonadicField(default: EmptyView.self)
    public var separator: Separator {
        set { self._layout.overlay.content = newValue }
        get { self._layout.overlay.content }
    }
    
    private let _layout: AnchorLayout<
        SubstrateLayout<
            ViewLayout< Background >,
            MarginLayout< ViewLayout< Content > >
        >,
        ViewLayout< Separator >
    >

    public init(
        background: Background,
        content: Content,
        separator: Separator
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
            .width(.fill)
            .height(.fit)
            .clipsToBounds(false)
    }
    
}

extension BarView : IViewSupportEnable where Content : IViewSupportEnable {
    
    public var isEnabled: Bool {
        set { self.content.isEnabled = newValue }
        get { self.content.isEnabled }
    }
    
    public var onEnabled: Signal< Void, Void > {
        self.content.onEnabled
    }
    
}

extension BarView : IViewSupportColor where Background : IViewSupportColor {
    
    public var color: Color {
        set { self.background.color = newValue }
        get { self.background.color }
    }
    
}
