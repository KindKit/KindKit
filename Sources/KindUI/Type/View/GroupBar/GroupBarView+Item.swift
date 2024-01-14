//
//  KindKit
//

import KindMath

protocol IGroupBarItemViewDelegate : AnyObject {
    
    func pressed(_ item: GroupBarView.Item)
    
}

public extension GroupBarView {
    
    final class Item : IWidgetView {
        
        public private(set) var body: CustomView
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
        
        weak var delegate: IGroupBarItemViewDelegate?
        
        private var _layout: GroupBarView.Item.Layout
        private var _tapGesture = TapGesture()
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

private extension GroupBarView.Item {
    
    func _setup() {
        self._tapGesture
            .onTriggered(self, { $0.delegate?.pressed($0) })
    }
    
}

public extension GroupBarView.Item {
    
    @inlinable
    @discardableResult
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IView) -> Self {
        self.content = value
        return self
    }
    
}

extension GroupBarView.Item : IViewHighlightable {
}

extension GroupBarView.Item : IViewSelectable {
}

extension GroupBarView.Item : IViewLockable {
}
