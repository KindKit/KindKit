//
//  KindKit
//

import Foundation

protocol IGroupBarItemViewDelegate : AnyObject {
    
    func pressed(_ item: UI.View.GroupBar.Item)
    
}

public extension UI.View.GroupBar {
    
    final class Item : IUIWidgetView, IUIViewHighlightable, IUIViewSelectable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) var body: UI.View.Custom
        public var isSelected: Bool {
            set {
                guard self._isSelected != newValue else { return }
                self._isSelected = newValue
                self.triggeredChangeStyle(false)
            }
            get { self._isSelected }
        }
        public var inset: InsetFloat {
            set { self._layout.inset = newValue }
            get { self._layout.inset }
        }
        public var content: IUIView {
            didSet {
                guard self.content !== oldValue else { return }
                self._layout.content = UI.Layout.Item(self.content)
            }
        }
        
        unowned var delegate: IGroupBarItemViewDelegate?
        
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
            self._setup()
        }
        
        public convenience init(
            content: IUIView,
            configure: (Item) -> Void
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
    
    func _setup() {
        self._tapGesture
            .onTriggered(self, { $0.delegate?.pressed($0) })
    }
    
}
