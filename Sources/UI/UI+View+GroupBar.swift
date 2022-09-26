//
//  KindKit
//

import Foundation

public protocol IGroupBarViewDelegate : AnyObject {
    
    func pressed(groupBar: UI.View.GroupBar, item: UI.View.GroupBar.Item)
    
}

public extension UI.View {

    final class GroupBar : IUIWidgetView, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public unowned var delegate: IGroupBarViewDelegate?
        public var items: [UI.View.GroupBar.Item] {
            set(value) {
                for itemView in self._items {
                    itemView.delegate = nil
                }
                self._items = value
                for itemView in self._items {
                    itemView.delegate = self
                }
                self._contentLayout.items = self.items.compactMap({ UI.Layout.Item($0) })
            }
            get { return self._items }
        }
        public var itemsInset: InsetFloat {
            set(value) { self._contentLayout.itemsInset = value }
            get { return self._contentLayout.itemsInset }
        }
        public var itemsSpacing: Float {
            set(value) { self._contentLayout.itemsSpacing = value }
            get { return self._contentLayout.itemsSpacing }
        }
        public var selected: UI.View.GroupBar.Item? {
            set(value) {
                guard self._selected !== value else { return }
                self._selected?.select(false)
                self._selected = value
                self._selected?.select(true)
            }
            get { return self._selected }
        }
        public private(set) var body: UI.View.Bar
        
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
