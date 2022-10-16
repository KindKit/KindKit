//
//  KindKit
//

import Foundation

public protocol IPageBarViewDelegate : AnyObject {
    
    func pressed(pageBar: UI.View.PageBar, item: UI.View.PageBar.Item)
    
}

public extension UI.View {

    final class PageBar : IUIWidgetView, IUIViewReusable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public private(set) var body: UI.View.Bar
        public var leading: IUIView? {
            didSet {
                guard self.leading !== oldValue else { return }
                self._contentLayout.leading = self.leading.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var trailing: IUIView? {
            didSet {
                guard self.trailing !== oldValue else { return }
                self._contentLayout.trailing = self.trailing.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var indicator: IUIView {
            didSet {
                guard self.indicator !== oldValue else { return }
                self._contentLayout.indicator = UI.Layout.Item(self.indicator)
            }
        }
        public var items: [UI.View.PageBar.Item] {
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
            get { return self._items }
        }
        public var itemsInset: InsetFloat {
            set { self._contentLayout.itemsInset = newValue }
            get { return self._contentLayout.itemsInset }
        }
        public var itemsSpacing: Float {
            set { self._contentLayout.itemsSpacing = newValue }
            get { return self._contentLayout.itemsSpacing }
        }
        public var selected: UI.View.PageBar.Item? {
            set {
                guard self._selected !== newValue else { return }
                self._selected?.select(false)
                self._selected = newValue
                if let selectedView = self._selected {
                    selectedView.select(true)
                    if let contentOffset = self._contentView.contentOffset(with: selectedView, horizontal: .center, vertical: .center) {
                        self._contentView.contentOffset(contentOffset, normalized: true)
                    }
                    if let item = selectedView.appearedItem {
                        self._contentLayout.indicatorState = .alias(current: item)
                    }
                } else {
                    self._contentLayout.indicatorState = .empty
                }
            }
            get { return self._selected }
        }
        public unowned var delegate: IPageBarViewDelegate?
        
        private var _contentLayout: ContentLayout
        private var _contentView: UI.View.Scroll
        private var _items: [UI.View.PageBar.Item] = []
        private var _selected: UI.View.PageBar.Item?
        private var _transitionContentOffset: PointFloat?
        private var _transitionSelectedView: IUIView?
        
        public init(
            indicator: IUIView
        ) {
            self.indicator = indicator
            self._contentLayout = ContentLayout(
                indicator: indicator
            )
            self._contentView = UI.View.Scroll(self._contentLayout)
                .direction(.horizontal)
            self.body = .init(
                placement: .top,
                content: self._contentView
            )
        }
        
        public convenience init(
            indicator: IUIView,
            configure: (UI.View.PageBar) -> Void
        ) {
            self.init(indicator: indicator)
            self.modify(configure)
        }
        
        public func beginTransition() {
            self._transitionContentOffset = self._contentView.contentOffset
            self._transitionSelectedView = self._selected
        }
        
        public func transition(to view: UI.View.PageBar.Item, progress: PercentFloat) {
            if let currentContentOffset = self._transitionContentOffset {
                if let targetContentOffset = self._contentView.contentOffset(with: view, horizontal: .center, vertical: .center) {
                    self._contentView.contentOffset(currentContentOffset.lerp(targetContentOffset, progress: progress), normalized: true)
                }
            }
            if let currentView = self._transitionSelectedView, let currentItem = currentView.appearedItem, let nextItem = view.appearedItem {
                self._contentLayout.indicatorState = .transition(current: currentItem, next: nextItem, progress: progress)
            }
        }
        
        public func finishTransition(to view: UI.View.PageBar.Item) {
            self._transitionContentOffset = nil
            self._transitionSelectedView = nil
            self.selected = view
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
    func leading(_ value: IUIView?) -> Self {
        self.leading = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailing(_ value: IUIView?) -> Self {
        self.trailing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func indicator(_ value: IUIView) -> Self {
        self.indicator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func items(_ value: [UI.View.PageBar.Item]) -> Self {
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
    func selected(_ value: UI.View.PageBar.Item?) -> Self {
        self.selected = value
        return self
    }
    
}


extension UI.View.PageBar : IPageBarItemViewDelegate {
    
    func pressed(_ item: UI.View.PageBar.Item) {
        self.delegate?.pressed(pageBar: self, item: item)
    }
    
}
