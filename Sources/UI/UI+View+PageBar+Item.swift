//
//  KindKit
//

import Foundation

protocol IPageBarItemViewDelegate : AnyObject {
    
    func pressed(_ itemView: UI.View.PageBar.Item)
    
}

public extension UI.View.PageBar {
    
    final class Item : IUIWidgetView, IUIViewHighlightable, IUIViewSelectable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        unowned var delegate: IPageBarItemViewDelegate?
        
        public var contentInset: InsetFloat {
            set(value) { self._layout.contentInset = value }
            get { return self._layout.contentInset }
        }
        public var contentView: IUIView {
            didSet(oldValue) {
                guard self.contentView !== oldValue else { return }
                self._layout.contentItem = UI.Layout.Item(self.contentView)
            }
        }
        public var isSelected: Bool {
            set(value) {
                if self._isSelected != value {
                    self._isSelected = value
                    self.triggeredChangeStyle(false)
                }
            }
            get { return self._isSelected }
        }
        public private(set) var body: UI.View.Custom
        
        private var _layout: UI.View.PageBar.Item.Layout
        private var _tapGesture = UI.Gesture.Tap()
        private var _isSelected: Bool = false
        
        public init(
            _ contentView: IUIView
        ) {
            self.contentView = contentView
            self._layout = UI.View.PageBar.Item.Layout(contentView)
            self.body = UI.View.Custom(self._layout)
                .gestures([ self._tapGesture ])
                .shouldHighlighting(true)
            self._init()
        }
        
    }
    
}

public extension UI.View.PageBar.Item {
    
    @discardableResult
    func contentView(_ value: IUIView) -> Self {
        self.contentView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func contentInset(_ value: InsetFloat) -> Self {
        self.contentInset = value
        return self
    }
    
}

private extension UI.View.PageBar.Item {
    
    func _init() {
        self._tapGesture.onTriggered({ [weak self] _ in
            guard let self = self else { return }
            self.delegate?.pressed(self)
        })
    }
    
}
