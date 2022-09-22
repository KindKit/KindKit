//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Bar : IUIWidgetView, IUIViewDynamicSizeable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var placement: Placement {
            set(value) { self._layout.placement = value }
            get { return self._layout.placement }
        }
        public var size: Float? {
            set(value) { self._layout.size = value }
            get { return self._layout.size }
        }
        public var safeArea: InsetFloat {
            set(value) { self._layout.safeArea = value }
            get { return self._layout.safeArea }
        }
        public var separatorView: IUIView? {
            didSet(oldValue) {
                guard self.separatorView !== oldValue else { return }
                self._layout.separatorItem = self.separatorView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var color: Color? {
            set(value) { self._backgroundView.color = value }
            get { return self._backgroundView.color }
        }
        public var cornerRadius: UI.CornerRadius {
            set(value) { self._backgroundView.cornerRadius = value }
            get { return self._backgroundView.cornerRadius }
        }
        public var border: UI.Border {
            set(value) { self._backgroundView.border = value }
            get { return self._backgroundView.border }
        }
        public var shadow: UI.Shadow? {
            set(value) { self._backgroundView.shadow = value }
            get { return self._backgroundView.shadow }
        }
        public private(set) var body: UI.View.Custom
        
        private var _layout: Layout
        private var _backgroundView = UI.View.Empty()

        public init(
            placement: Placement,
            contentView: IUIView
        ) {
            self._layout = Layout(
                placement: placement,
                backgroundView: self._backgroundView,
                contentView: contentView
            )
            self.body = .init(self._layout)
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
        set(value) { self.body.placement = value }
        get { return self.body.placement }
    }
    
    @inlinable
    var size: Float? {
        set(value) { self.body.size = value }
        get { return self.body.size }
    }
    
    @inlinable
    var safeArea: InsetFloat {
        set(value) { self.body.safeArea = value }
        get { return self.body.safeArea }
    }
    
    @inlinable
    var separatorView: IUIView? {
        set(value) { self.body.separatorView = value }
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