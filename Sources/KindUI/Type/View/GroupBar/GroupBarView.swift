//
//  KindKit
//

import KindMath

public protocol IGroupBarViewDelegate : AnyObject {
    
    func pressed(groupBar: GroupBarView, item: GroupBarView.Item)
    
}

public final class GroupBarView : IWidgetView {
    
    public private(set) var body: BarView
    public var items: [GroupBarView.Item] {
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
    public var selected: GroupBarView.Item? {
        set {
            guard self._selected !== newValue else { return }
            self._selected?.select(false)
            self._selected = newValue
            self._selected?.select(true)
        }
        get { self._selected }
    }
    public weak var delegate: IGroupBarViewDelegate?
    
    private var _contentLayout: ContentLayout
    private var _contentView: CustomView
    private var _items: [GroupBarView.Item]
    private var _selected: GroupBarView.Item?
    
    public init() {
        self._items = []
        self._contentLayout = ContentLayout()
        self._contentView = CustomView()
            .content(self._contentLayout)
        self.body = .init(
            placement: .bottom,
            content: self._contentView
        )
    }
    
}

public extension GroupBarView {
    
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
    func items(_ value: [GroupBarView.Item]) -> Self {
        self.items = value
        return self
    }
    
    @inlinable
    @discardableResult
    func items(_ value: () -> [GroupBarView.Item]) -> Self {
        return self.items(value())
    }

    @inlinable
    @discardableResult
    func items(_ value: (Self) -> [GroupBarView.Item]) -> Self {
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
    func selected(_ value: GroupBarView.Item?) -> Self {
        self.selected = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selected(_ value: () -> GroupBarView.Item?) -> Self {
        return self.selected(value())
    }

    @inlinable
    @discardableResult
    func selected(_ value: (Self) -> GroupBarView.Item?) -> Self {
        return self.selected(value(self))
    }
    
}

extension GroupBarView : IViewReusable {
}

#if os(iOS)

extension GroupBarView : IViewTransformable {
}

#endif

extension GroupBarView : IViewColorable {
}

extension GroupBarView : IViewAlphable {
}

extension GroupBarView : IViewLockable {
}

extension GroupBarView : IGroupBarItemViewDelegate {
    
    func pressed(_ itemView: GroupBarView.Item) {
        self.delegate?.pressed(groupBar: self, item: itemView)
    }
    
}
