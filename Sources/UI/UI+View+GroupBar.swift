//
//  KindKit
//

import Foundation

public protocol IGroupBarViewDelegate : AnyObject {
    
    func pressed(groupBar: UI.View.GroupBar, item: UI.View.GroupBar.Item)
    
}

public extension UI.View {

    final class GroupBar : IUIWidgetView, IUIViewReusable, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) var body: UI.View.Bar
        public var items: [UI.View.GroupBar.Item] {
            set {
                for itemView in self._items {
                    itemView.delegate = nil
                }
                self._items = newValue
                for itemView in self._items {
                    itemView.delegate = self
                }
                self._contentLayout.items = newValue.map({ UI.Layout.Item($0) })
            }
            get { self._items }
        }
        public var itemsInset: InsetFloat {
            set { self._contentLayout.itemsInset = newValue }
            get { self._contentLayout.itemsInset }
        }
        public var itemsSpacing: Float {
            set { self._contentLayout.itemsSpacing = newValue }
            get { self._contentLayout.itemsSpacing }
        }
        public var selected: UI.View.GroupBar.Item? {
            set {
                guard self._selected !== newValue else { return }
                self._selected?.select(false)
                self._selected = newValue
                self._selected?.select(true)
            }
            get { self._selected }
        }
        public unowned var delegate: IGroupBarViewDelegate?
        
        private var _contentLayout: ContentLayout
        private var _contentView: UI.View.Custom
        private var _items: [UI.View.GroupBar.Item]
        private var _selected: UI.View.GroupBar.Item?
        
        public init() {
            self._items = []
            self._contentLayout = ContentLayout()
            self._contentView = UI.View.Custom(self._contentLayout)
            self.body = .init(
                placement: .bottom,
                content: self._contentView
            )
        }
        
        public convenience init(
            configure: (UI.View.GroupBar) -> Void
        ) {
            self.init()
            self.modify(configure)
        }
        
    }
    
}

public extension UI.View.GroupBar {
    
    @inlinable
    @discardableResult
    func items(_ value: [UI.View.GroupBar.Item]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemsInset(_ value: InsetFloat) -> Self {
        self.itemsInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemsSpacing(_ value: Float) -> Self {
        self.itemsSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: UI.View.GroupBar.Item?) -> Self {
        self.selected = value
        return self
    }
    
}

extension UI.View.GroupBar : IGroupBarItemViewDelegate {
    
    func pressed(_ itemView: UI.View.GroupBar.Item) {
        self.delegate?.pressed(groupBar: self, item: itemView)
    }
    
}
