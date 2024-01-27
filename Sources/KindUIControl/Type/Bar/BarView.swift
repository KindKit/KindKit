//
//  KindKit
//

import KindUI
import KindMonadicMacro

@KindMonadic
public final class BarView< BackgroundType : IView, ContentType : IView, SeparatorType : IView > : IComposite, IView, IViewDynamicSizeable,  IViewAlphable {
    
    public let body = LayoutView< Layout >()
    
    public var placement: Placement {
        self._layout.placement
    }
    
    @KindMonadicProperty
    public var background: BackgroundType? {
        set { self._layout.background = newValue }
        get { self._layout.background }
    }
    
    @KindMonadicProperty
    public var contentInset: Inset {
        set { self._layout.contentInset = newValue }
        get { self._layout.contentInset }
    }
    
    @KindMonadicProperty
    public var content: ContentType? {
        set { self._layout.content = newValue }
        get { self._layout.content }
    }
    
    @KindMonadicProperty
    public var separator: SeparatorType? {
        set { self._layout.separator = newValue }
        get { self._layout.separator }
    }
    
    private let _layout: Layout

    public init(placement: Placement) {
        self._layout = .init(placement: placement)
        self.body.content(self._layout)
    }
    
}

extension BarView : IViewEnableable where ContentType : IViewEnableable {
    
    public var isEnabled: Bool {
        set { self.content?.isEnabled = newValue }
        get { self.content?.isEnabled ?? false }
    }
    
}

extension BarView : IViewColorable where BackgroundType : IViewColorable {
    
    public var color: Color? {
        set { self.background?.color = newValue }
        get { self.background?.color }
    }
    
}
