//
//  KindKit
//

import Foundation

protocol IGroupBarItemViewDelegate : AnyObject {
    
    func pressed(_ itemView: UI.View.GroupBar.Item)
    
}

public extension UI.View.GroupBar {
    
    final class Item : IUIWidgetView, IUIViewHighlightable, IUIViewSelectable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        unowned var delegate: IGroupBarItemViewDelegate?
        
        public var inset: InsetFloat {
            set(value) { self._layout.inset = value }
            get { return self._layout.inset }
        }
        public var content: IUIView {
            didSet(oldValue) {
                guard self.content !== oldValue else { return }
                self._layout.content = UI.Layout.Item(self.content)
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
        
        private var _layout: UI.View.GroupBar.Item.Layout
        private var _tapGesture = UI.Gesture.Tap()
        private var _isSelected: Bool = false
        
        public init(
            _ content: IUIView
        ) {
            self.content = content
            self._layout = UI.View.GroupBar.Item.Layout(content)
            self.body = UI.View.Custom(self._layout)
                .gestures([ self._tapGesture ])
                .shouldHighlighting(true)
            self._init()
        }
        
        public convenience init(
            content: IUIView,
            configure: (Item) -> Void
        ) {
            self.init(content)
            self.modify(configure)
        }
        
    }
    
}

public extension UI.View.GroupBar.Item {
    
    @inlinable
    @discardableResult
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @discardableResult
    func content(_ value: IUIView) -> Self {
        self.content = value
        return self
    }
    
}

private extension UI.View.GroupBar.Item {
    
    func _init() {
        self._tapGesture.onTriggered({ [weak self] _ in
            guard let self = self else { return }
            self.delegate?.pressed(self)
        })
    }
    
}
