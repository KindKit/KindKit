//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Bar : IUIWidgetView {
        
        public let body: UI.View.Custom
        public var placement: Placement {
            set { self._layout.placement = newValue }
            get { self._layout.placement }
        }
        public var size: Double? {
            set { self._layout.size = newValue }
            get { self._layout.size }
        }
        public var safeArea: Inset {
            set { self._layout.safeArea = newValue }
            get { self._layout.safeArea }
        }
        public var separator: IUIView? {
            didSet {
                guard self.separator !== oldValue else { return }
                self._layout.separator = self.separator
            }
        }
        
        private var _layout: Layout
        private var _background: UI.View.Color

        public init(
            placement: Placement,
            content: IUIView
        ) {
            self._background = UI.View.Color()
            self._layout = Layout(
                placement: placement,
                background: self._background,
                content: content
            )
            self.body = .init()
                .content(self._layout)
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
    func size(_ value: Double?) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func safeArea(_ value: Inset) -> Self {
        self.safeArea = value
        return self
    }
    
    @inlinable
    @discardableResult
    func separator(_ value: IUIView?) -> Self {
        self.separator = value
        return self
    }
    
}

extension UI.View.Bar : IUIViewReusable {
}

#if os(iOS)

extension UI.View.Bar : IUIViewTransformable {
}

#endif

extension UI.View.Bar : IUIViewDynamicSizeable {
}

extension UI.View.Bar : IUIViewLockable {
}

extension UI.View.Bar : IUIViewColorable {
    
    public var color: UI.Color? {
        set { self._background.color = newValue }
        get { self._background.color }
    }
    
}

extension UI.View.Bar : IUIViewAlphable {
}

public extension IUIView where Self == UI.View.Bar {
    
    @inlinable
    static func bar(
        placement: UI.View.Bar.Placement,
        content: IUIView
    ) -> Self {
        return .init(
            placement: placement,
            content: content
        )
    }
    
}
