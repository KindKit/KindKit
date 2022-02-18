//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class GroupBarView : BarView, IGroupBarView {
    
    public var delegate: IGroupBarViewDelegate?
    public var itemInset: InsetFloat {
        set(value) { self._contentLayout.itemInset = value }
        get { return self._contentLayout.itemInset }
    }
    public var itemSpacing: Float {
        set(value) { self._contentLayout.itemSpacing = value }
        get { return self._contentLayout.itemSpacing }
    }
    public var itemViews: [IBarItemView] {
        set(value) {
            for itemView in self._itemViews {
                itemView.delegate = nil
            }
            self._itemViews = value
            for itemView in self._itemViews {
                itemView.delegate = self
            }
            self._contentLayout.items = self.itemViews.compactMap({ LayoutItem(view: $0) })
        }
        get { return self._itemViews }
    }
    public var selectedItemView: IBarItemView? {
        set(value) {
            guard self._selectedItemView !== value else { return }
            self._selectedItemView?.select(false)
            self._selectedItemView = value
            self._selectedItemView?.select(true)
        }
        get { return self._selectedItemView }
    }
    
    private var _contentLayout: Layout
    private var _contentView: CustomView< Layout >
    private var _itemViews: [IBarItemView]
    private var _selectedItemView: IBarItemView?
    
    public init(
        itemInset: InsetFloat = InsetFloat(horizontal: 12, vertical: 0),
        itemSpacing: Float = 4,
        size: Float? = nil,
        separatorView: IView? = nil,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self._itemViews = []
        self._contentLayout = Layout(
            itemInset: itemInset,
            itemSpacing: itemSpacing,
            items: []
        )
        self._contentView = CustomView(
            contentLayout: self._contentLayout
        )
        super.init(
            placement: .bottom,
            size: size,
            separatorView: separatorView,
            contentView: self._contentView,
            color: color,
            border: border,
            cornerRadius: cornerRadius,
            shadow: shadow,
            alpha: alpha,
            isHidden: isHidden
        )
    }
    
    @discardableResult
    public func itemInset(_ value: InsetFloat) -> Self {
        self.itemInset = value
        return self
    }
    
    @discardableResult
    public func itemSpacing(_ value: Float) -> Self {
        self.itemSpacing = value
        return self
    }
    
    @discardableResult
    public func itemViews(_ value: [IBarItemView]) -> Self {
        self.itemViews = value
        return self
    }
    
    @discardableResult
    public func selectedItemView(_ value: IBarItemView?) -> Self {
        self.selectedItemView = value
        return self
    }
    
}

extension GroupBarView : IBarItemViewDelegate {
    
    public func pressed(barItemView: IBarItemView) {
        self.delegate?.pressed(groupBar: self, itemView: barItemView)
    }
    
}

private extension GroupBarView {
    
    class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var itemInset: InsetFloat {
            didSet { self.setNeedForceUpdate() }
        }
        var itemSpacing: Float {
            didSet { self.setNeedForceUpdate() }
        }
        var items: [LayoutItem] {
            didSet {
                self._cache = Array< SizeFloat? >(repeating: nil, count: self.items.count)
                self.setNeedForceUpdate()
            }
        }
        
        private var _cache: [SizeFloat?]

        init(
            itemInset: InsetFloat,
            itemSpacing: Float,
            items: [LayoutItem]
        ) {
            self.itemInset = itemInset
            self.itemSpacing = itemSpacing
            self.items = items
            self._cache = Array< SizeFloat? >(repeating: nil, count: items.count)
        }
        
        func invalidate(item: LayoutItem) {
            if let index = self.items.firstIndex(where: { $0 === item }) {
                self._cache.remove(at: index)
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            return ListLayout.Helper.layout(
                bounds: bounds,
                direction: .horizontal,
                inset: self.itemInset,
                spacing: self.itemSpacing,
                minSize: bounds.size.width / Float(self.items.count),
                maxSize: bounds.size.width,
                items: self.items,
                cache: &self._cache
            )
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return ListLayout.Helper.size(
                available: available,
                direction: .horizontal,
                inset: self.itemInset,
                spacing: self.itemSpacing,
                minSize: available.width / Float(self.items.count),
                maxSize: available.width,
                items: self.items
            )
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            return self.visible(items: self.items, for: bounds)
        }
        
    }
    
}
