//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

public final class BarView : IWidgetView {
    
    public let body: CustomView
    public var placement: Placement {
        self._layout.placement
    }
    public var size: Double? {
        set { self._layout.size = newValue }
        get { self._layout.size }
    }
    public var safeArea: Inset {
        set { self._layout.safeArea = newValue }
        get { self._layout.safeArea }
    }
    public var separator: IView? {
        didSet {
            guard self.separator !== oldValue else { return }
            self._layout.separator = self.separator
        }
    }
    
    private let _layout: Layout
    private let _background = ColorView()

    public init(
        placement: Placement,
        content: IView
    ) {
        self._layout = Layout(
            placement: placement,
            background: self._background,
            content: content
        )
        self.body = .init()
            .content(self._layout)
    }
    
}

public extension BarView {
    
    @inlinable
    @discardableResult
    func size(_ value: Double?) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: () -> Double?) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> Double?) -> Self {
        return self.size(value(self))
    }
    
    @inlinable
    @discardableResult
    func safeArea(_ value: Inset) -> Self {
        self.safeArea = value
        return self
    }
    
    @inlinable
    @discardableResult
    func safeArea(_ value: () -> Inset) -> Self {
        return self.safeArea(value())
    }

    @inlinable
    @discardableResult
    func safeArea(_ value: (Self) -> Inset) -> Self {
        return self.safeArea(value(self))
    }
    
    @inlinable
    @discardableResult
    func separator(_ value: IView?) -> Self {
        self.separator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func separator(_ value: () -> IView?) -> Self {
        return self.separator(value())
    }

    @inlinable
    @discardableResult
    func separator(_ value: (Self) -> IView?) -> Self {
        return self.separator(value(self))
    }
    
}

extension BarView : IViewReusable {
}

#if os(iOS)

extension BarView : IViewTransformable {
}

#endif

extension BarView : IViewDynamicSizeable {
}

extension BarView : IViewLockable {
}

extension BarView : IViewColorable {
    
    public var color: Color? {
        set { self._background.color = newValue }
        get { self._background.color }
    }
    
}

extension BarView : IViewAlphable {
}
