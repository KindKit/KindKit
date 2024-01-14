//
//  KindKit
//

import KindMath

public protocol IPageBarViewDelegate : AnyObject {
    
    func pressed(pageBar: PageBarView, item: PageBarView.Item)
    
}

public final class PageBarView : IWidgetView {
    
    public private(set) var body: BarView
    public var leading: IView? {
        didSet {
            guard self.leading !== oldValue else { return }
            self._contentLayout.leading = self.leading
        }
    }
    public var trailing: IView? {
        didSet {
            guard self.trailing !== oldValue else { return }
            self._contentLayout.trailing = self.trailing
        }
    }
    public var indicator: IView? {
        didSet {
            guard self.indicator !== oldValue else { return }
            self._contentLayout.indicator = self.indicator
        }
    }
    public var items: [PageBarView.Item] {
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
    public var selected: PageBarView.Item? {
        set {
            guard self._selected !== newValue else { return }
            self._selected?.select(false)
            self._selected = newValue
            if let selectedView = self._selected {
                selectedView.select(true)
                if let contentOffset = self._contentView.contentOffset(with: selectedView, horizontal: .center, vertical: .center) {
                    self._contentView.contentOffset = contentOffset
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
    private var _contentView: ScrollView
    private var _items: [PageBarView.Item] = []
    private var _selected: PageBarView.Item?
    private var _transitionContentOffset: Point?
    private var _transitionSelectedView: IView?
    
    public init() {
        self._contentLayout = ContentLayout()
        self._contentView = ScrollView()
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
    
    public func transition(to view: PageBarView.Item, progress: Percent) {
        if let currentContentOffset = self._transitionContentOffset {
            if let targetContentOffset = self._contentView.contentOffset(with: view, horizontal: .center, vertical: .center) {
                self._contentView.contentOffset = currentContentOffset.lerp(targetContentOffset, progress: progress)
            }
        }
        if let current = self._transitionSelectedView {
            self._contentLayout.indicatorState = .transition(current: current, next: view, progress: progress)
        }
    }
    
    public func finishTransition(to view: PageBarView.Item) {
        self._transitionContentOffset = nil
        self._transitionSelectedView = nil
        self.selected = view
    }
    
    public func cancelTransition() {
        self._transitionContentOffset = nil
        self._transitionSelectedView = nil
    }
    
}

public extension PageBarView {
    
    @inlinable
    @discardableResult
    func size(_ value: Double?) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: () -> Double?) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> Double?) -> Self {
        return self.size(value(self))
    }
    
    @inlinable
    @discardableResult
    func leading(_ value: IView?) -> Self {
        self.leading = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leading(_ value: () -> IView?) -> Self {
        return self.leading(value())
    }

    @inlinable
    @discardableResult
    func leading(_ value: (Self) -> IView?) -> Self {
        return self.leading(value(self))
    }
    
    @inlinable
    @discardableResult
    func trailing(_ value: IView?) -> Self {
        self.trailing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailing(_ value: () -> IView?) -> Self {
        return self.trailing(value())
    }

    @inlinable
    @discardableResult
    func trailing(_ value: (Self) -> IView?) -> Self {
        return self.trailing(value(self))
    }
    
    @inlinable
    @discardableResult
    func indicator(_ value: IView?) -> Self {
        self.indicator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func indicator(_ value: () -> IView?) -> Self {
        return self.indicator(value())
    }

    @inlinable
    @discardableResult
    func indicator(_ value: (Self) -> IView?) -> Self {
        return self.indicator(value(self))
    }
    
    @inlinable
    @discardableResult
    func items(_ value: [PageBarView.Item]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func items(_ value: () -> [PageBarView.Item]) -> Self {
        return self.items(value())
    }

    @inlinable
    @discardableResult
    func items(_ value: (Self) -> [PageBarView.Item]) -> Self {
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
    func selected(_ value: PageBarView.Item?) -> Self {
        self.selected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: () -> PageBarView.Item?) -> Self {
        return self.selected(value())
    }

    @inlinable
    @discardableResult
    func selected(_ value: (Self) -> PageBarView.Item?) -> Self {
        return self.selected(value(self))
    }
    
}

extension PageBarView : IViewReusable {
}

#if os(iOS)

extension PageBarView : IViewTransformable {
}

#endif

extension PageBarView : IViewColorable {
}

extension PageBarView : IViewAlphable {
}

extension PageBarView : IViewLockable {
}

extension PageBarView : IPageBarItemViewDelegate {
    
    func pressed(_ item: PageBarView.Item) {
        self.delegate?.pressed(pageBar: self, item: item)
    }
    
}
