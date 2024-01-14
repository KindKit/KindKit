//
//  KindKit
//

import KindMath

protocol IPageBarItemViewDelegate : AnyObject {
    
    func pressed(_ item: PageBarView.Item)
    
}

public extension PageBarView {
    
    final class Item : IWidgetView {
        
        public let body: CustomView
        public var inset: Inset {
            set { self._layout.inset = newValue }
            get { self._layout.inset }
        }
        public var content: IView? {
            didSet {
                guard self.content !== oldValue else { return }
                self._layout.content = self.content
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
        public let tapGesture = TapGesture()
        
        weak var delegate: IPageBarItemViewDelegate?
        
        private var _layout: PageBarView.Item.Layout
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

public extension PageBarView.Item {
    
    @inlinable
    @discardableResult
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IView?) -> Self {
        self.content = value
        return self
    }
    
}

extension PageBarView.Item : IViewReusable {
}

extension PageBarView.Item : IViewHighlightable {
}

extension PageBarView.Item : IViewSelectable {
}

extension PageBarView.Item : IViewLockable {
}

private extension PageBarView.Item {
    
    func _setup() {
        self.tapGesture
            .onTriggered(self, { $0.delegate?.pressed($0) })
    }
    
}
