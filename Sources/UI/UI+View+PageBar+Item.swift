//
//  KindKit
//

import Foundation

protocol IPageBarItemViewDelegate : AnyObject {
    
    func pressed(_ item: UI.View.PageBar.Item)
    
}

public extension UI.View.PageBar {
    
    final class Item : IUIWidgetView, IUIViewReusable, IUIViewHighlightable, IUIViewSelectable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public let body: UI.View.Custom
        public var isSelected: Bool {
            set {
                guard self._isSelected != newValue else { return }
                self._isSelected = newValue
                self.triggeredChangeStyle(false)
            }
            get { return self._isSelected }
        }
        public var inset: InsetFloat {
            set { self._layout.inset = newValue }
            get { return self._layout.inset }
        }
        public var content: IUIView {
            didSet {
                guard self.content !== oldValue else { return }
                self._layout.content = UI.Layout.Item(self.content)
            }
        }
        public let tapGesture = UI.Gesture.Tap()
        
        unowned var delegate: IPageBarItemViewDelegate?
        
        private var _layout: UI.View.PageBar.Item.Layout
        private var _isSelected: Bool = false
        
        public init(
            _ content: IUIView
        ) {
            self.content = content
            self._layout = UI.View.PageBar.Item.Layout(content)
            self.body = UI.View.Custom(self._layout)
                .gestures([ self.tapGesture ])
                .shouldHighlighting(true)
            self._setup()
        }
        
        public convenience init(
            content: IUIView,
            configure: (UI.View.PageBar.Item) -> Void
        ) {
            self.init(content)
            self.modify(configure)
        }
        
        public convenience init(
            _ content: IUILayout
        ) {
            self.init(UI.View.Custom(content))
        }
        
        public convenience init(
            content: IUILayout,
            configure: (Item) -> Void
        ) {
            self.init(content)
            self.modify(configure)
        }
        
    }
    
}

public extension UI.View.PageBar.Item {
    
    @discardableResult
    func content(_ value: IUIView) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
}

private extension UI.View.PageBar.Item {
    
    func _setup() {
        self.tapGesture.onTriggered({ [weak self] _ in
            guard let self = self else { return }
            self.delegate?.pressed(self)
        })
    }
    
}
