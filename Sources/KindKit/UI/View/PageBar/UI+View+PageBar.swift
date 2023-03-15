//
//  KindKit
//

import Foundation

public protocol IPageBarViewDelegate : AnyObject {
    
    func pressed(pageBar: UI.View.PageBar, item: UI.View.PageBar.Item)
    
}

public extension UI.View {

    final class PageBar : IUIWidgetView {
        
        public private(set) var body: UI.View.Bar
        public var leading: IUIView? {
            didSet {
                guard self.leading !== oldValue else { return }
                self._contentLayout.leading = self.leading
            }
        }
        public var trailing: IUIView? {
            didSet {
                guard self.trailing !== oldValue else { return }
                self._contentLayout.trailing = self.trailing
            }
        }
        public var indicator: IUIView? {
            didSet {
                guard self.indicator !== oldValue else { return }
                self._contentLayout.indicator = self.indicator
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
                self._contentLayout.items = newValue
            }
            get { self._items }
        }
        public var itemsInset: Inset {
            set { self._contentLayout.itemsInset = newValue }
            get { self._contentLayout.itemsInset }
        }
        public var itemsSpacing: Double {
            set { self._contentLayout.itemsSpacing = newValue }
            get { self._contentLayout.itemsSpacing }
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
                    self._contentLayout.indicatorState = .alias(current: selectedView)
                } else {
                    self._contentLayout.indicatorState = .empty
                }
            }
            get { self._selected }
        }
        public weak var delegate: IPageBarViewDelegate?
        
        private var _contentLayout: ContentLayout
        private var _contentView: UI.View.Scroll
        private var _items: [UI.View.PageBar.Item] = []
        private var _selected: UI.View.PageBar.Item?
        private var _transitionContentOffset: Point?
        private var _transitionSelectedView: IUIView?
        
        public init() {
            self._contentLayout = ContentLayout()
            self._contentView = UI.View.Scroll()
                .direction(.horizontal)
                .content(self._contentLayout)
            self.body = .init(
                placement: .top,
                content: self._contentView
            )
        }
        
        public func beginTransition() {
            self._transitionContentOffset = self._contentView.contentOffset
            self._transitionSelectedView = self._selected
        }
        
        public func transition(to view: UI.View.PageBar.Item, progress: Percent) {
            if let currentContentOffset = self._transitionContentOffset {
                if let targetContentOffset = self._contentView.contentOffset(with: view, horizontal: .center, vertical: .center) {
                    self._contentView.contentOffset(currentContentOffset.lerp(targetContentOffset, progress: progress), normalized: true)
                }
            }
            if let current = self._transitionSelectedView {
                self._contentLayout.indicatorState = .transition(current: current, next: view, progress: progress)
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
    func leading(_ value: () -> IUIView?) -> Self {
        return self.leading(value())
    }

    @inlinable
    @discardableResult
    func leading(_ value: (Self) -> IUIView?) -> Self {
        return self.leading(value(self))
    }
    
    @inlinable
    @discardableResult
    func trailing(_ value: IUIView?) -> Self {
        self.trailing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailing(_ value: () -> IUIView?) -> Self {
        return self.trailing(value())
    }

    @inlinable
    @discardableResult
    func trailing(_ value: (Self) -> IUIView?) -> Self {
        return self.trailing(value(self))
    }
    
    @inlinable
    @discardableResult
    func indicator(_ value: IUIView?) -> Self {
        self.indicator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func indicator(_ value: () -> IUIView?) -> Self {
        return self.indicator(value())
    }

    @inlinable
    @discardableResult
    func indicator(_ value: (Self) -> IUIView?) -> Self {
        return self.indicator(value(self))
    }
    
    @inlinable
    @discardableResult
    func items(_ value: [UI.View.PageBar.Item]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func items(_ value: () -> [UI.View.PageBar.Item]) -> Self {
        return self.items(value())
    }

    @inlinable
    @discardableResult
    func items(_ value: (Self) -> [UI.View.PageBar.Item]) -> Self {
        return self.items(value(self))
    }
    
    @inlinable
    @discardableResult
    func itemsInset(_ value: Inset) -> Self {
        self.itemsInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemsInset(_ value: () -> Inset) -> Self {
        return self.itemsInset(value())
    }

    @inlinable
    @discardableResult
    func itemsInset(_ value: (Self) -> Inset) -> Self {
        return self.itemsInset(value(self))
    }
    
    @inlinable
    @discardableResult
    func itemsSpacing(_ value: Double) -> Self {
        self.itemsSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func itemsSpacing(_ value: () -> Double) -> Self {
        return self.itemsSpacing(value())
    }

    @inlinable
    @discardableResult
    func itemsSpacing(_ value: (Self) -> Double) -> Self {
        return self.itemsSpacing(value(self))
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: UI.View.PageBar.Item?) -> Self {
        self.selected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: () -> UI.View.PageBar.Item?) -> Self {
        return self.selected(value())
    }

    @inlinable
    @discardableResult
    func selected(_ value: (Self) -> UI.View.PageBar.Item?) -> Self {
        return self.selected(value(self))
    }
    
}

extension UI.View.PageBar : IUIViewReusable {
}

#if os(iOS)

extension UI.View.PageBar : IUIViewTransformable {
}

#endif

extension UI.View.PageBar : IUIViewColorable {
}

extension UI.View.PageBar : IUIViewAlphable {
}

extension UI.View.PageBar : IUIViewLockable {
}

extension UI.View.PageBar : IPageBarItemViewDelegate {
    
    func pressed(_ item: UI.View.PageBar.Item) {
        self.delegate?.pressed(pageBar: self, item: item)
    }
    
}

public extension IUIView where Self == UI.View.PageBar {
    
    @inlinable
    static func pageBar(_ items: [UI.View.PageBar.Item]) -> Self {
        return .init().items(items)
    }
    
}
