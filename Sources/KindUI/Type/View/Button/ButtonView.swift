//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMath

public final class ButtonView : IWidgetView {
    
    public private(set) var body: ControlView
    public var size: DynamicSize = .init(.fit, .fit) {
        didSet {
            guard self.size != oldValue else { return }
            self.setNeedLayout()
        }
    }
    public var inset: Inset {
        set { self._layout.inset = newValue }
        get { self._layout.inset }
    }
    public var alignment: ButtonView.Alignment {
        set { self._layout.alignment = newValue }
        get { self._layout.alignment }
    }
    public var background: IView? {
        didSet { self._layout.background = self.background }
    }
    public var spinner: IView? {
        didSet { self._layout.spinner = self.spinner }
    }
    public var spinnerPosition: ButtonView.SpinnerPosition {
        set { self._layout.spinnerPosition = newValue }
        get { self._layout.spinnerPosition }
    }
    public var primary: IView? {
        didSet { self._layout.primary = self.primary }
    }
    public var secondary: IView? {
        didSet { self._layout.secondary = self.secondary }
    }
    public var secondaryPosition: ButtonView.SecondaryPosition {
        set { self._layout.secondaryPosition = newValue }
        get { self._layout.secondaryPosition }
    }
    public var secondarySpacing: Double {
        set { self._layout.secondarySpacing = newValue }
        get { self._layout.secondarySpacing }
    }
    public var isAnimating: Bool {
        set { self._layout.spinnerAnimating = newValue }
        get { self._layout.spinnerAnimating }
    }
    public var isSelected: Bool {
        set {
            guard self._isSelected != newValue else { return }
            self._isSelected = newValue
            self.triggeredChangeStyle(false)
        }
        get { self._isSelected }
    }
    
    private var _layout: Layout
    private var _isSelected: Bool = false
    
    public init() {
        self._layout = Layout()
        self.body = .init()
            .content(self._layout)
            .shouldHighlighting(true)
            .shouldPressed(true)
    }
    
    public func size(available: Size) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(
            available: available,
            size: { self.body.size(available: $0) }
        )
    }
    
}

public extension ButtonView {
    
    @inlinable
    @discardableResult
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func inset(_ value: () -> Inset) -> Self {
        return self.inset(value())
    }

    @inlinable
    @discardableResult
    func inset(_ value: (Self) -> Inset) -> Self {
        return self.inset(value(self))
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: ButtonView.Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> ButtonView.Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> ButtonView.Alignment) -> Self {
        return self.alignment(value(self))
    }
    
    @inlinable
    @discardableResult
    func background(_ value: IView?) -> Self {
        self.background = value
        return self
    }
    
    @inlinable
    @discardableResult
    func background(_ value: () -> IView?) -> Self {
        return self.background(value())
    }

    @inlinable
    @discardableResult
    func background(_ value: (Self) -> IView?) -> Self {
        return self.background(value(self))
    }
    
    @inlinable
    @discardableResult
    func spinnerPosition(_ value: ButtonView.SpinnerPosition) -> Self {
        self.spinnerPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinnerPosition(_ value: () -> ButtonView.SpinnerPosition) -> Self {
        return self.spinnerPosition(value())
    }

    @inlinable
    @discardableResult
    func spinnerPosition(_ value: (Self) -> ButtonView.SpinnerPosition) -> Self {
        return self.spinnerPosition(value(self))
    }
    
    @inlinable
    @discardableResult
    func spinner(_ value: IView?) -> Self {
        self.spinner = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinner(_ value: () -> IView?) -> Self {
        return self.spinner(value())
    }

    @inlinable
    @discardableResult
    func spinner(_ value: (Self) -> IView?) -> Self {
        return self.spinner(value(self))
    }
    
    @inlinable
    @discardableResult
    func primary(_ value: IView?) -> Self {
        self.primary = value
        return self
    }
    
    @inlinable
    @discardableResult
    func primary(_ value: () -> IView?) -> Self {
        return self.primary(value())
    }

    @inlinable
    @discardableResult
    func primary(_ value: (Self) -> IView?) -> Self {
        return self.primary(value(self))
    }
    
    @inlinable
    @discardableResult
    func secondary(_ value: IView?) -> Self {
        self.secondary = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondary(_ value: () -> IView?) -> Self {
        return self.secondary(value())
    }

    @inlinable
    @discardableResult
    func secondary(_ value: (Self) -> IView?) -> Self {
        return self.secondary(value(self))
    }
    
    @inlinable
    @discardableResult
    func secondaryPosition(_ value: ButtonView.SecondaryPosition) -> Self {
        self.secondaryPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryPosition(_ value: () -> ButtonView.SecondaryPosition) -> Self {
        return self.secondaryPosition(value())
    }

    @inlinable
    @discardableResult
    func secondaryPosition(_ value: (Self) -> ButtonView.SecondaryPosition) -> Self {
        return self.secondaryPosition(value(self))
    }
    
    @inlinable
    @discardableResult
    func secondarySpacing(_ value: Double) -> Self {
        self.secondarySpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondarySpacing(_ value: () -> Double) -> Self {
        return self.secondarySpacing(value())
    }

    @inlinable
    @discardableResult
    func secondarySpacing(_ value: (Self) -> Double) -> Self {
        return self.secondarySpacing(value(self))
    }
    
}

extension ButtonView : IViewReusable {
}

#if os(iOS)

extension ButtonView : IViewTransformable {
}

#endif

extension ButtonView : IViewDynamicSizeable {
}

extension ButtonView : IViewAnimatable {
}

extension ButtonView : IViewHighlightable {
}

extension ButtonView : IViewSelectable {
}

extension ButtonView : IViewLockable {
}

extension ButtonView : IViewPressable {
}

extension ButtonView : IViewAlphable {
}
