//
//  KindKit
//

import Foundation

protocol IGroupBarViewDelegate : AnyObject {
    
    func pressed(groupBar: UI.View.GroupBar, itemView: UI.View.GroupBar.Item)
    
}

public extension UI.View {

    final class GroupBar : IUIWidgetView, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var itemInset: InsetFloat {
            set(value) { self._contentLayout.itemInset = value }
            get { return self._contentLayout.itemInset }
        }
        public var itemSpacing: Float {
            set(value) { self._contentLayout.itemSpacing = value }
            get { return self._contentLayout.itemSpacing }
        }
        public var itemViews: [UI.View.GroupBar.Item] {
            set(value) {
                for itemView in self._itemViews {
                    itemView.delegate = nil
                }
                self._itemViews = value
                for itemView in self._itemViews {
                    itemView.delegate = self
                }
                self._contentLayout.items = self.itemViews.compactMap({ UI.Layout.Item($0) })
            }
            get { return self._itemViews }
        }
        public var selectedItemView: UI.View.GroupBar.Item? {
            set(value) {
                guard self._selectedItemView !== value else { return }
                self._selectedItemView?.select(false)
                self._selectedItemView = value
                self._selectedItemView?.select(true)
            }
            get { return self._selectedItemView }
        }
        public private(set) var body: UI.View.Bar
        
        unowned var delegate: IGroupBarViewDelegate?
        
        private var _contentLayout: ContentLayout
        private var _contentView: UI.View.Custom
        private var _itemViews: [UI.View.GroupBar.Item]
        private var _selectedItemView: UI.View.GroupBar.Item?
        
        public init() {
            self._itemViews = []
            self._contentLayout = ContentLayout()
            self._contentView = UI.View.Custom(self._contentLayout)
            self.body = .init(
                placement: .bottom,
                contentView: self._contentView
            )
        }
        
    }
    
}

public extension UI.View.GroupBar {
    
    @inlinable
    @discardableResult
    func itemInset(_ value: InsetFloat) -> Self {
        self.itemInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemSpacing(_ value: Float) -> Self {
        self.itemSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemViews(_ value: [UI.View.GroupBar.Item]) -> Self {
        self.itemViews = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectedItemView(_ value: UI.View.GroupBar.Item?) -> Self {
        self.selectedItemView = value
        return self
    }
    
}

extension UI.View.GroupBar : IGroupBarItemViewDelegate {
    
    func pressed(_ itemView: UI.View.GroupBar.Item) {
        self.delegate?.pressed(groupBar: self, itemView: itemView)
    }
    
}
