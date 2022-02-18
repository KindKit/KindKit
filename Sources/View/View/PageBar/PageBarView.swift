//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class PageBarView : BarView, IPageBarView {
    
    public var delegate: IPageBarViewDelegate?
    public var leadingView: IView? {
        didSet(oldValue) {
            guard self.leadingView !== oldValue else { return }
            self._contentLayout.leadingItem = self.leadingView.flatMap({ LayoutItem(view: $0) })
        }
    }
    public var trailingView: IView? {
        didSet(oldValue) {
            guard self.trailingView !== oldValue else { return }
            self._contentLayout.trailingItem = self.trailingView.flatMap({ LayoutItem(view: $0) })
        }
    }
    public var indicatorView: IView {
        didSet(oldValue) {
            guard self.indicatorView !== oldValue else { return }
            self._contentLayout.indicatorItem = LayoutItem(view: self.indicatorView)
        }
    }
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
            if let selectedView = self._selectedItemView {
                selectedView.select(true)
                if let contentOffset = self._contentView.contentOffset(with: selectedView, horizontal: .center, vertical: .center) {
                    self._contentView.contentOffset(contentOffset, normalized: true)
                }
                if let item = selectedView.item {
                    self._contentLayout.indicatorState = .alias(current: item)
                }
            } else {
                self._contentLayout.indicatorState = .empty
            }
        }
        get { return self._selectedItemView }
    }
    
    private var _contentLayout: Layout
    private var _contentView: ScrollView< Layout >
    private var _itemViews: [IBarItemView]
    private var _selectedItemView: IBarItemView?
    private var _transitionContentOffset: PointFloat?
    private var _transitionSelectedView: IView?
    
    public init(
        leadingView: IView? = nil,
        trailingView: IView? = nil,
        indicatorView: IView,
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
        self.leadingView = leadingView
        self.trailingView = trailingView
        self.indicatorView = indicatorView
        self._itemViews = []
        self._contentLayout = Layout(
            leadingItem: leadingView.flatMap({ LayoutItem(view: $0) }),
            trailingItem: trailingView.flatMap({ LayoutItem(view: $0) }),
            indicatorItem: LayoutItem(view: indicatorView),
            indicatorState: .empty,
            itemInset: itemInset,
            itemSpacing: itemSpacing,
            items: []
        )
        self._contentView = ScrollView(
            direction: .horizontal,
            contentLayout: self._contentLayout
        )
        super.init(
            placement: .top,
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
    public func leadingView(_ value: IView?) -> Self {
        self.leadingView = value
        return self
    }
    
    @discardableResult
    public func trailingView(_ value: IView?) -> Self {
        self.trailingView = value
        return self
    }
    
    @discardableResult
    public func indicatorView(_ value: IView) -> Self {
        self.indicatorView = value
        return self
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
    
    public func beginTransition() {
        self._transitionContentOffset = self._contentView.contentOffset
        self._transitionSelectedView = self._selectedItemView
    }
    
    public func transition(to view: IBarItemView, progress: Float) {
        if let currentContentOffset = self._transitionContentOffset {
            if let targetContentOffset = self._contentView.contentOffset(with: view, horizontal: .center, vertical: .center) {
                self._contentView.contentOffset(currentContentOffset.lerp(targetContentOffset, progress: progress), normalized: true)
            }
        }
        if let currentView = self._transitionSelectedView, let currentItem = currentView.item, let nextItem = view.item {
            self._contentLayout.indicatorState = .transition(current: currentItem, next: nextItem, progress: progress)
        }
    }
    
    public func finishTransition(to view: IBarItemView) {
        self._transitionContentOffset = nil
        self._transitionSelectedView = nil
        self.selectedItemView = view
    }
    
    public func cancelTransition() {
        self._transitionContentOffset = nil
        self._transitionSelectedView = nil
    }
    
}

extension PageBarView : IBarItemViewDelegate {
    
    public func pressed(barItemView: IBarItemView) {
        self.delegate?.pressed(pageBar: self, itemView: barItemView)
    }
    
}

private extension PageBarView {
    
    class Layout : ILayout {
        
        enum IndicatorState {
            case empty
            case alias(current: LayoutItem)
            case transition(current: LayoutItem, next: LayoutItem, progress: Float)
        }
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var leadingItem: LayoutItem? {
            didSet { self.setNeedForceUpdate() }
        }
        var trailingItem: LayoutItem? {
            didSet { self.setNeedForceUpdate() }
        }
        var indicatorItem: LayoutItem {
            didSet { self.setNeedForceUpdate() }
        }
        var indicatorState: IndicatorState {
            didSet { self.setNeedUpdate() }
        }
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
            leadingItem: LayoutItem?,
            trailingItem: LayoutItem?,
            indicatorItem: LayoutItem,
            indicatorState: IndicatorState,
            itemInset: InsetFloat,
            itemSpacing: Float,
            items: [LayoutItem]
        ) {
            self.leadingItem = leadingItem
            self.trailingItem = trailingItem
            self.indicatorItem = indicatorItem
            self.indicatorState = indicatorState
            self.itemInset = itemInset
            self.itemSpacing = itemSpacing
            self.items = items
            self._cache = Array< SizeFloat? >(repeating: nil, count: items.count)
        }
        
        func invalidate(item: LayoutItem) {
            if let index = self.items.firstIndex(where: { $0 === item }) {
                self._cache[index] = nil
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let leadingSize: SizeFloat
            if let item = self.leadingItem {
                leadingSize = item.size(available: bounds.size)
                item.frame = RectFloat(
                    left: bounds.left,
                    size: leadingSize
                )
            } else {
                leadingSize = .zero
            }
            let trailingSize: SizeFloat
            if let item = self.trailingItem {
                trailingSize = item.size(available: bounds.size)
                item.frame = RectFloat(
                    right: bounds.right,
                    size: trailingSize
                )
            } else {
                trailingSize = .zero
            }
            let itemsSize = ListLayout.Helper.layout(
                bounds: bounds.inset(InsetFloat(
                    top: 0,
                    left: leadingSize.width,
                    right: trailingSize.width,
                    bottom: 0
                )),
                direction: .horizontal,
                inset: self.itemInset,
                spacing: self.itemSpacing,
                maxSize: bounds.size.width,
                items: self.items,
                cache: &self._cache
            )
            return SizeFloat(
                width: leadingSize.width + itemsSize.width + trailingSize.width,
                height: max(leadingSize.height, itemsSize.height, trailingSize.height)
            )
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let leadingSize: SizeFloat
            if let item = self.leadingItem {
                leadingSize = item.size(available: available)
            } else {
                leadingSize = .zero
            }
            let trailingSize: SizeFloat
            if let item = self.trailingItem {
                trailingSize = item.size(available: available)
            } else {
                trailingSize = .zero
            }
            let itemsSize = ListLayout.Helper.size(
                available: available.inset(InsetFloat(
                    top: 0,
                    left: leadingSize.width,
                    right: trailingSize.width,
                    bottom: 0
                )),
                direction: .horizontal,
                inset: self.itemInset,
                spacing: self.itemSpacing,
                maxSize: available.width,
                items: self.items
            )
            return SizeFloat(
                width: leadingSize.width + itemsSize.width + trailingSize.width,
                height: max(leadingSize.height, itemsSize.height, trailingSize.height)
            )
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            var items = self.visible(items: self.items, for: bounds)
            switch self.indicatorState {
            case .empty:
                break
            case .alias(let current):
                self.indicatorItem.frame = current.frame
                items.append(self.indicatorItem)
            case .transition(let current, let next, let progress):
                self.indicatorItem.frame = current.frame.lerp(next.frame, progress: progress)
                items.append(self.indicatorItem)
            }
            if let item = self.leadingItem {
                item.frame = RectFloat(
                    left: bounds.left,
                    size: item.frame.size
                )
                items.append(item)
            }
            if let item = self.trailingItem {
                item.frame = RectFloat(
                    right: bounds.right,
                    size: item.frame.size
                )
                items.append(item)
            }
            return items
        }
        
    }
    
}
