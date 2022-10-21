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
                self._layout.background = self.background.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self._layout.content = self.content.flatMap({ UI.Layout.Item($0) })
            }
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
#if os(iOS)
        public let pressedGesture = UI.Gesture.Tap()
#endif
        public let onPressed: Signal.Empty< Void > = .init()
        
        private var _isSelected: Bool = false
        private var _layout: Layout
        
        public init() {
            self._layout = Layout()
            self.body = UI.View.Custom()
                .content(self._layout)
#if os(iOS)
                .gestures([ self.pressedGesture ])
#endif
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
    
}

private extension UI.View.Cell {
    
    func _setup() {
#if os(iOS)
        self.pressedGesture
            .onShouldBegin(self, { $0.shouldPressed })
            .onTriggered(self, { $0.onPressed.emit() })
#endif
    }
    
}

extension UI.View.Cell : IUIViewReusable {
}

extension UI.View.Cell : IUIViewDynamicSizeable {
}

extension UI.View.Cell : IUIViewHighlightable {
}

extension UI.View.Cell : IUIViewSelectable {
}

extension UI.View.Cell : IUIViewLockable {
}

extension UI.View.Cell : IUIViewPressable {
}
