//
//  KindKit
//

#if os(iOS)
import UIKit
#endif
import KindEvent
import KindGraphics
import KindMath

public final class CellView : IWidgetView {
    
    public private(set) var body: CustomView
    public var background: IView? {
        didSet {
            guard self.background !== oldValue else { return }
            self._layout.background = self.background
        }
    }
    public var content: IView? {
        didSet {
            guard self.content !== oldValue else { return }
            self._layout.content = self.content
        }
    }
    public var contentInset: Inset {
        set { self._layout.contentInset = newValue }
        get { self._layout.contentInset }
    }
    public var shouldPressed: Bool = true
    public var isSelected: Bool {
        set {
            guard self._isSelected != newValue else { return }
            self._isSelected = newValue
            self.triggeredChangeStyle(false)
        }
        get { self._isSelected }
    }
    public let pressedGesture = TapGesture()
    public let onPressed = Signal< Void, Void >()
    
    private var _isSelected: Bool = false
    private let _layout = Layout()
    
    public init() {
        self.body = .init()
            .content(self._layout)
            .gestures([ self.pressedGesture ])
            .shouldHighlighting(true)
        
        self.pressedGesture
            .onShouldBegin(self, { $0.shouldPressed })
            .onTriggered(self, { $0.onPressed.emit() })
    }
    
}

public extension CellView {
    
    @inlinable
    @discardableResult
    func background(_ value: IView) -> Self {
        self.background = value
        return self
    }
    
    @inlinable
    @discardableResult
    func background(_ value: () -> IView) -> Self {
        return self.background(value())
    }

    @inlinable
    @discardableResult
    func background(_ value: (Self) -> IView) -> Self {
        return self.background(value(self))
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IView) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> IView) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> IView) -> Self {
        return self.content(value(self))
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: Inset) -> Self {
        self.contentInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: () -> Inset) -> Self {
        return self.contentInset(value())
    }

    @inlinable
    @discardableResult
    func contentInset(_ value: (Self) -> Inset) -> Self {
        return self.contentInset(value(self))
    }
    
}

extension CellView : IViewReusable {
}

#if os(iOS)

extension CellView : IViewTransformable {
}

#endif

extension CellView : IViewDynamicSizeable {
}

extension CellView : IViewDragDestinationtable {
}

extension CellView : IViewDragSourceable {
}

extension CellView : IViewHighlightable {
}

extension CellView : IViewSelectable {
}

extension CellView : IViewLockable {
}

extension CellView : IViewPressable {
}

extension CellView : IViewColorable {
}

extension CellView : IViewAlphable {
}
