//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Button : IUIWidgetView {
        
        public private(set) var body: UI.View.Control
        public var size: UI.Size.Dynamic = .init(.fit, .fit) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var inset: Inset {
            set { self._layout.inset = newValue }
            get { self._layout.inset }
        }
        public var alignment: Alignment {
            set { self._layout.alignment = newValue }
            get { self._layout.alignment }
        }
        public var background: IUIView? {
            didSet { self._layout.background = self.background }
        }
        public var spinner: IUIView? {
            didSet { self._layout.spinner = self.spinner }
        }
        public var spinnerPosition: SpinnerPosition {
            set { self._layout.spinnerPosition = newValue }
            get { self._layout.spinnerPosition }
        }
        public var primary: IUIView? {
            didSet { self._layout.primary = self.primary }
        }
        public var secondary: IUIView? {
            didSet { self._layout.secondary = self.secondary }
        }
        public var secondaryPosition: SecondaryPosition {
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
    
}

public extension UI.View.Button {
    
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
    func alignment(_ value: Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> Alignment) -> Self {
        return self.alignment(value(self))
    }
    
    @inlinable
    @discardableResult
    func background(_ value: IUIView?) -> Self {
        self.background = value
        return self
    }
    
    @inlinable
    @discardableResult
    func background(_ value: () -> IUIView?) -> Self {
        return self.background(value())
    }

    @inlinable
    @discardableResult
    func background(_ value: (Self) -> IUIView?) -> Self {
        return self.background(value(self))
    }
    
    @inlinable
    @discardableResult
    func spinnerPosition(_ value: SpinnerPosition) -> Self {
        self.spinnerPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinnerPosition(_ value: () -> SpinnerPosition) -> Self {
        return self.spinnerPosition(value())
    }

    @inlinable
    @discardableResult
    func spinnerPosition(_ value: (Self) -> SpinnerPosition) -> Self {
        return self.spinnerPosition(value(self))
    }
    
    @inlinable
    @discardableResult
    func spinner(_ value: IUIView?) -> Self {
        self.spinner = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinner(_ value: () -> IUIView?) -> Self {
        return self.spinner(value())
    }

    @inlinable
    @discardableResult
    func spinner(_ value: (Self) -> IUIView?) -> Self {
        return self.spinner(value(self))
    }
    
    @inlinable
    @discardableResult
    func primary(_ value: IUIView?) -> Self {
        self.primary = value
        return self
    }
    
    @inlinable
    @discardableResult
    func primary(_ value: () -> IUIView?) -> Self {
        return self.primary(value())
    }

    @inlinable
    @discardableResult
    func primary(_ value: (Self) -> IUIView?) -> Self {
        return self.primary(value(self))
    }
    
    @inlinable
    @discardableResult
    func secondary(_ value: IUIView?) -> Self {
        self.secondary = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondary(_ value: () -> IUIView?) -> Self {
        return self.secondary(value())
    }

    @inlinable
    @discardableResult
    func secondary(_ value: (Self) -> IUIView?) -> Self {
        return self.secondary(value(self))
    }
    
    @inlinable
    @discardableResult
    func secondaryPosition(_ value: SecondaryPosition) -> Self {
        self.secondaryPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryPosition(_ value: () -> SecondaryPosition) -> Self {
        return self.secondaryPosition(value())
    }

    @inlinable
    @discardableResult
    func secondaryPosition(_ value: (Self) -> SecondaryPosition) -> Self {
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

extension UI.View.Button : IUIViewReusable {
}

#if os(iOS)

extension UI.View.Button : IUIViewTransformable {
}

#endif

extension UI.View.Button : IUIViewDynamicSizeable {
}

extension UI.View.Button : IUIViewAnimatable {
}

extension UI.View.Button : IUIViewHighlightable {
}

extension UI.View.Button : IUIViewSelectable {
}

extension UI.View.Button : IUIViewLockable {
}

extension UI.View.Button : IUIViewPressable {
}

public extension IUIView where Self == UI.View.Button {
    
    @inlinable
    static func button() -> Self {
        return .init()
    }
    
}
