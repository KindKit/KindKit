//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

public extension UI.View {
    
    final class Cell : IUIWidgetView {
        
        public private(set) var body: UI.View.Custom
        public var background: IUIView? {
            didSet {
                guard self.background !== oldValue else { return }
                self._layout.background = self.background
            }
        }
        public var content: IUIView? {
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
        public let pressedGesture = UI.Gesture.Tap()
        public let onPressed: Signal.Empty< Void > = .init()
        
        private var _isSelected: Bool = false
        private var _layout: Layout
        
        public init() {
            self._layout = Layout()
            self.body = UI.View.Custom()
                .content(self._layout)
                .gestures([ self.pressedGesture ])
                .shouldHighlighting(true)
            self._setup()
        }
        
    }
    
}

public extension UI.View.Cell {
    
    @inlinable
    @discardableResult
    func background(_ value: IUIView) -> Self {
        self.background = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IUIView) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: Inset) -> Self {
        self.contentInset = value
        return self
    }
    
}

private extension UI.View.Cell {
    
    func _setup() {
        self.pressedGesture
            .onShouldBegin(self, { $0.shouldPressed })
            .onTriggered(self, { $0.onPressed.emit() })
    }
    
}

extension UI.View.Cell : IUIViewReusable {
}

#if os(iOS)

extension UI.View.Cell : IUIViewTransformable {
}

#endif

extension UI.View.Cell : IUIViewDynamicSizeable {
}

extension UI.View.Cell : IUIViewDragDestinationtable {
}

extension UI.View.Cell : IUIViewDragSourceable {
}

extension UI.View.Cell : IUIViewHighlightable {
}

extension UI.View.Cell : IUIViewSelectable {
}

extension UI.View.Cell : IUIViewLockable {
}

extension UI.View.Cell : IUIViewPressable {
}

extension UI.View.Cell : IUIViewColorable {
}

extension UI.View.Cell : IUIViewAlphable {
}

public extension IUIView where Self == UI.View.Cell {
    
    @inlinable
    static func cell() -> Self {
        return .init()
    }
    
}
