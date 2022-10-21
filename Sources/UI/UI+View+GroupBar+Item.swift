//
//  KindKit
//

import Foundation

protocol IGroupBarItemViewDelegate : AnyObject {
    
    func pressed(_ item: UI.View.GroupBar.Item)
    
}

public extension UI.View.GroupBar {
    
    final class Item : IUIWidgetView {
        
        public private(set) var body: UI.View.Custom
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
        
        unowned var delegate: IGroupBarItemViewDelegate?
        
        private var _layout: UI.View.GroupBar.Item.Layout
        private var _tapGesture = UI.Gesture.Tap()
        private var _isSelected: Bool = false
        
        public init() {
            self._layout = .init()
            self.body = .init()
                .content(self._layout)
                .gestures([ self._tapGesture ])
                .shouldHighlighting(true)
            self._setup()
        }
        
    }
    
}

private extension UI.View.GroupBar.Item {
    
    func _setup() {
        self._tapGesture
            .onTriggered(self, { $0.delegate?.pressed($0) })
    }
    
}

public extension UI.View.GroupBar.Item {
    
    @inlinable
    @discardableResult
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IUIView) -> Self {
        self.content = value
        return self
    }
    
}

extension UI.View.GroupBar.Item : IUIViewHighlightable {
}

extension UI.View.GroupBar.Item : IUIViewSelectable {
}

extension UI.View.GroupBar.Item : IUIViewLockable {
}
