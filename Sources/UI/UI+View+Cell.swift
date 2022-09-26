//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif

public extension UI.View {
    
    final class Cell : IUIWidgetView, IUIViewHighlightable, IUIViewSelectable, IUIViewLockable, IUIViewPressable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var isSelected: Bool {
            set(value) {
                guard self._isSelected != value else { return }
                self._isSelected = value
                self.triggeredChangeStyle(false)
            }
            get { return self._isSelected }
        }
        public var shouldPressed: Bool = true
        public var content: IUIView {
            didSet(oldValue) {
                guard self.content !== oldValue else { return }
                self._layout.content = UI.Layout.Item(self.content)
            }
        }
#if os(iOS)
        public let pressedGesture = UI.Gesture.Tap()
#endif
        public private(set) var body: UI.View.Custom
        public var onPressed: ((UI.View.Cell) -> Void)?
        
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
    func shouldPressed(_ value: Bool) -> Self {
        self.shouldPressed = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IUIView) -> Self {
        self.content = value
        return self
    }
    
}

public extension UI.View.Cell {
    
    @inlinable
    @discardableResult
    func onPressed(_ value: ((UI.View.Cell) -> Void)?) -> Self {
        self.onPressed = value
        return self
    }
    
}

private extension UI.View.Cell {
    
    func _setup() {
#if os(iOS)
        self.pressedGesture.onShouldBegin({ [unowned self] _ in
            return self.shouldPressed
        }).onTriggered({ [unowned self] _ in
            self.onPressed?(self)
        })
#endif
    }
    
}
