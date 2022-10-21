//
//  KindKit
//

import Foundation

protocol IPageBarItemViewDelegate : AnyObject {
    
    func pressed(_ item: UI.View.PageBar.Item)
    
}

public extension UI.View.PageBar {
    
    final class Item : IUIWidgetView {
        
        public let body: UI.View.Custom
        public var inset: InsetFloat {
            set { self._layout.inset = newValue }
            get { self._layout.inset }
        }
        public var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self._layout.content = self.content.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var isSelected: Bool {
            set {
                guard self._isSelected != newValue else { return }
                self._isSelected = newValue
                self.triggeredChangeStyle(false)
            }
            get { self._isSelected }
        }
        public let tapGesture = UI.Gesture.Tap()
        
        unowned var delegate: IPageBarItemViewDelegate?
        
        private var _layout: UI.View.PageBar.Item.Layout
        private var _isSelected: Bool = false
        
        public init() {
            self._layout = .init()
            self.body = .init()
                .content(self._layout)
                .gestures([ self.tapGesture ])
                .shouldHighlighting(true)
            self._setup()
        }
        
    }
    
}

public extension UI.View.PageBar.Item {
    
    @inlinable
    @discardableResult
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IUIView?) -> Self {
        self.content = value
        return self
    }
    
}

extension UI.View.PageBar.Item : IUIViewReusable {
}

extension UI.View.PageBar.Item : IUIViewHighlightable {
}

extension UI.View.PageBar.Item : IUIViewSelectable {
}

extension UI.View.PageBar.Item : IUIViewLockable {
}

private extension UI.View.PageBar.Item {
    
    func _setup() {
        self.tapGesture
            .onTriggered(self, { $0.delegate?.pressed($0) })
    }
    
}
