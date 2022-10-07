//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

public extension UI.View {
    
    final class Cell : IUIWidgetView, IUIViewReusable, IUIViewHighlightable, IUIViewSelectable, IUIViewLockable, IUIViewPressable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var isSelected: Bool {
            set {
                guard self._isSelected != newValue else { return }
                self._isSelected = newValue
                self.triggeredChangeStyle(false)
            }
            get { self._isSelected }
        }
        public var shouldPressed: Bool = true
        public var content: IUIView {
            didSet {
                guard self.content !== oldValue else { return }
                self._layout.content = UI.Layout.Item(self.content)
            }
        }
#if os(iOS)
        public let pressedGesture = UI.Gesture.Tap()
#endif
        public private(set) var body: UI.View.Custom
        public let onPressed: Signal.Empty< Void > = .init()
        
        private var _layout: Layout
        private var _isSelected: Bool = false
        
        public init(
            _ content: IUIView
        ) {
            self.content = content
            self._layout = Layout(content)
            self.body = UI.View.Custom(self._layout)
                .shouldHighlighting(true)
#if os(iOS)
                .gestures([ self.pressedGesture ])
#endif
            self._setup()
        }
        
        public convenience init(
            content: IUIView,
            configure: (UI.View.Cell) -> Void
        ) {
            self.init(content)
            self.modify(configure)
        }
        
    }
    
}

public extension UI.View.Cell {
    
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
