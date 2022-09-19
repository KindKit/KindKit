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
        public private(set) var contentView: IUIView {
            didSet(oldValue) {
                guard self.contentView !== oldValue else { return }
                self._layout.contentItem = UI.Layout.Item(self.contentView)
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
            _ contentView: IUIView
        ) {
            self.contentView = contentView
            self._layout = Layout(contentItem: UI.Layout.Item(contentView))
            self.body = UI.View.Custom(self._layout)
#if os(iOS)
                .gestures([ self._pressedGesture ])
#endif
                .shouldHighlighting(true)
            self._init()
        }
        
        public convenience init(customView: IUILayout) {
            self.init(UI.View.Custom(customView))
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
    func contentView(_ value: IUIView) -> Self {
        self.contentView = value
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
