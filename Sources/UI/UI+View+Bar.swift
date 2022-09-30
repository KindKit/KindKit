//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Bar : IUIWidgetView, IUIViewReusable, IUIViewDynamicSizeable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) var body: UI.View.Custom
        public var color: UI.Color? {
            set { self._background.color = newValue }
            get { return self._background.color }
        }
        public var cornerRadius: UI.CornerRadius {
            set { self._background.cornerRadius = newValue }
            get { return self._background.cornerRadius }
        }
        public var border: UI.Border {
            set { self._background.border = newValue }
            get { return self._background.border }
        }
        public var shadow: UI.Shadow? {
            set { self._background.shadow = newValue }
            get { return self._background.shadow }
        }
        public var placement: Placement {
            set { self._layout.placement = newValue }
            get { return self._layout.placement }
        }
        public var size: Float? {
            set { self._layout.size = newValue }
            get { return self._layout.size }
        }
        public var safeArea: InsetFloat {
            set { self._layout.safeArea = newValue }
            get { return self._layout.safeArea }
        }
        public var separatorView: IUIView? {
            didSet {
                guard self.separatorView !== oldValue else { return }
                self._layout.separatorItem = self.separatorView.flatMap({ UI.Layout.Item($0) })
            }
        }
        
        private var _layout: Layout
        private var _background = UI.View.Empty()

        public init(
            placement: Placement,
            content: IUIView
        ) {
            self._layout = Layout(
                placement: placement,
                background: self._background,
                content: content
            )
            self.body = .init(self._layout)
        }
        
        public convenience init(
            placement: Placement,
            content: IUIView,
            configure: (UI.View.Bar) -> Void
        ) {
            self.init(placement: placement, content: content)
            self.modify(configure)
        }
        
    }
    
}

public extension UI.View.Bar {
    
    @inlinable
    @discardableResult
    func placement(_ value: Placement) -> Self {
        self.placement = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: Float?) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func safeArea(_ value: InsetFloat) -> Self {
        self.safeArea = value
        return self
    }
    
    @inlinable
    @discardableResult
    func separatorView(_ value: IUIView?) -> Self {
        self.separatorView = value
        return self
    }
    
}

public extension IUIWidgetView where Body == UI.View.Bar {
    
    @inlinable
    var placement: UI.View.Bar.Placement {
        set { self.body.placement = newValue }
        get { return self.body.placement }
    }
    
    @inlinable
    var size: Float? {
        set { self.body.size = newValue }
        get { return self.body.size }
    }
    
    @inlinable
    var safeArea: InsetFloat {
        set { self.body.safeArea = newValue }
        get { return self.body.safeArea }
    }
    
    @inlinable
    var separatorView: IUIView? {
        set { self.body.separatorView = newValue }
        get { return self.body.separatorView }
    }
    
    @inlinable
    @discardableResult
    func placement(_ value: UI.View.Bar.Placement) -> Self {
        self.body.placement = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: Float?) -> Self {
        self.body.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func safeArea(_ value: InsetFloat) -> Self {
        self.body.safeArea = value
        return self
    }
    
    @inlinable
    @discardableResult
    func separatorView(_ value: IUIView?) -> Self {
        self.body.separatorView = value
        return self
    }
    
}
