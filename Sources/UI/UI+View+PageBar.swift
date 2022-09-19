//
//  KindKit
//

import Foundation

public protocol IPageBarViewDelegate : AnyObject {
    
    func pressed(pageBar: UI.View.PageBar, itemView: UI.View.PageBar.Item)
    
}

public extension UI.View {

    final class PageBar : IUIWidgetView, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var delegate: IPageBarViewDelegate?
        public var leadingView: IUIView? {
            didSet(oldValue) {
                guard self.leadingView !== oldValue else { return }
                self._contentLayout.leadingItem = self.leadingView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var trailingView: IUIView? {
            didSet(oldValue) {
                guard self.trailingView !== oldValue else { return }
                self._contentLayout.trailingItem = self.trailingView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var indicatorView: IUIView {
            didSet(oldValue) {
                guard self.indicatorView !== oldValue else { return }
                self._contentLayout.indicatorItem = UI.Layout.Item(self.indicatorView)
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
        public var itemViews: [UI.View.PageBar.Item] {
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
        public var selectedItemView: UI.View.PageBar.Item? {
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
        public private(set) var body: UI.View.Bar
        
        private var _contentLayout: ContentLayout
        private var _contentView: UI.View.Scroll
        private var _itemViews: [UI.View.PageBar.Item] = []
        private var _selectedItemView: UI.View.PageBar.Item?
        private var _transitionContentOffset: PointFloat?
        private var _transitionSelectedView: IUIView?
        
        public init(
            indicatorView: IUIView
        ) {
            self.indicatorView = indicatorView
            self._contentLayout = ContentLayout(
                indicatorView: indicatorView
            )
            self._contentView = UI.View.Scroll(self._contentLayout)
                .direction(.horizontal)
            self.body = .init(
                placement: .top,
                contentView: self._contentView
            )
        }
        
        public func beginTransition() {
            self._transitionContentOffset = self._contentView.contentOffset
            self._transitionSelectedView = self._selectedItemView
        }
        
        public func transition(to view: UI.View.PageBar.Item, progress: PercentFloat) {
            if let currentContentOffset = self._transitionContentOffset {
                if let targetContentOffset = self._contentView.contentOffset(with: view, horizontal: .center, vertical: .center) {
                    self._contentView.contentOffset(currentContentOffset.lerp(targetContentOffset, progress: progress), normalized: true)
                }
            }
            if let currentView = self._transitionSelectedView, let currentItem = currentView.item, let nextItem = view.item {
                self._contentLayout.indicatorState = .transition(current: currentItem, next: nextItem, progress: progress)
            }
        }
        
        public func finishTransition(to view: UI.View.PageBar.Item) {
            self._transitionContentOffset = nil
            self._transitionSelectedView = nil
            self.selectedItemView = view
        }
        
        public func cancelTransition() {
            self._transitionContentOffset = nil
            self._transitionSelectedView = nil
        }
        
    }
    
}

public extension UI.View.PageBar {
    
    @inlinable
    @discardableResult
    func leadingView(_ value: IUIView?) -> Self {
        self.leadingView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingView(_ value: IUIView?) -> Self {
        self.trailingView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func indicatorView(_ value: IUIView) -> Self {
        self.indicatorView = value
        return self
    }
    
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
    func itemViews(_ value: [UI.View.PageBar.Item]) -> Self {
        self.itemViews = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectedItemView(_ value: UI.View.PageBar.Item?) -> Self {
        self.selectedItemView = value
        return self
    }
    
}


extension UI.View.PageBar : IPageBarItemViewDelegate {
    
    func pressed(_ itemView: UI.View.PageBar.Item) {
        self.delegate?.pressed(pageBar: self, itemView: itemView)
    }
    
}
