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
        public var inset: InsetFloat {
            set { self._layout.inset = newValue }
            get { self._layout.inset }
        }
        public var alignment: Alignment {
            set { self._layout.alignment = newValue }
            get { self._layout.alignment }
        }
        public var background: IUIView? {
            didSet { self._layout.background = self.background.flatMap({ UI.Layout.Item($0) }) }
        }
        public var spinner: IUIView? {
            didSet { self._layout.spinner = self.spinner.flatMap({ UI.Layout.Item($0) }) }
        }
        public var spinnerPosition: SpinnerPosition {
            set { self._layout.spinnerPosition = newValue }
            get { self._layout.spinnerPosition }
        }
        public var primary: IUIView? {
            didSet { self._layout.primary = self.primary.flatMap({ UI.Layout.Item($0) }) }
        }
        public var primaryInset: InsetFloat {
            set { self._layout.primaryInset = newValue }
            get { self._layout.primaryInset }
        }
        public var secondary: IUIView? {
            didSet { self._layout.secondary = self.secondary.flatMap({ UI.Layout.Item($0) }) }
        }
        public var secondaryPosition: SecondaryPosition {
            set { self._layout.secondaryPosition = newValue }
            get { self._layout.secondaryPosition }
        }
        public var secondaryInset: InsetFloat {
            set { self._layout.secondaryInset = newValue }
            get { self._layout.secondaryInset }
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
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            return self.size.apply(
                available: available,
                sizeWithWidth: { self.body.size(available: .init(width: $0, height: available.height)) },
                sizeWithHeight: { self.body.size(available: .init(width: available.width, height: $0)) },
                size: { self.body.size(available: available) }
            )
        }
        
    }
    
}

public extension UI.View.Button {
    
    @inlinable
    @discardableResult
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func background(_ value: IUIView?) -> Self {
        self.background = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinnerPosition(_ value: SpinnerPosition) -> Self {
        self.spinnerPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spinner(_ value: IUIView?) -> Self {
        self.spinner = value
        return self
    }
    
    @inlinable
    @discardableResult
    func primary(_ value: IUIView?) -> Self {
        self.primary = value
        return self
    }
    
    @inlinable
    @discardableResult
    func primaryInset(_ value: InsetFloat) -> Self {
        self.primaryInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondary(_ value: IUIView?) -> Self {
        self.secondary = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryPosition(_ value: SecondaryPosition) -> Self {
        self.secondaryPosition = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryInset(_ value: InsetFloat) -> Self {
        self.secondaryInset = value
        return self
    }
    
}

extension UI.View.Button : IUIViewReusable {
}

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
