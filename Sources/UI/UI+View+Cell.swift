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
        public private(set) var content: IUIView {
            didSet(oldValue) {
                guard self.content !== oldValue else { return }
                self._layout.content = UI.Layout.Item(self.content)
            }
        }
        public private(set) var body: UI.View.Custom
        
        private var _layout: Layout
        private var _isSelected: Bool = false
#if os(iOS)
        private var _pressedGesture = UI.Gesture.Tap()
#endif
        private var _onPressed: ((UI.View.Cell) -> Void)?
        
        public init(
            _ content: IUIView
        ) {
            self.content = content
            self._layout = Layout(content)
            self.body = UI.View.Custom(self._layout)
#if os(iOS)
                .gestures([ self._pressedGesture ])
#endif
                .shouldHighlighting(true)
            self._init()
        }
        
        public convenience init(
            content: IUIView,
            configure: (UI.View.Cell) -> Void
        ) {
            self.init(content)
            self.modify(configure)
        }
        
        @discardableResult
        public func onPressed(_ value: ((UI.View.Cell) -> Void)?) -> Self {
            self._onPressed = value
            return self
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
    
    @discardableResult
    func content(_ value: IUIView) -> Self {
        self.content = value
        return self
    }
    
}

private extension UI.View.Cell {
    
    func _init() {
#if os(iOS)
        self._pressedGesture.onShouldBegin({ [unowned self] _ in
            return self.shouldPressed
        }).onTriggered({ [unowned self] _ in
            self._pressed()
        })
#endif
    }
    
#if os(iOS)
    
    func _pressed() {
        self._onPressed?(self)
    }
    
#endif
    
}
