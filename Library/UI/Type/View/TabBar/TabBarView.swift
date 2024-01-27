//
//  KindKit
//

import KindLayout
import KindMonadicMacro

fileprivate enum Defaults {
    
    static let placement = Placement.bottom
    static let inset = Inset(horizontal: 8, vertical: 4)
    static let spacing = Double(4)
    
}

@Monadic
public final class TabBarView< Background : IView, Separator : IView > : CompositorTrait, IView, IViewSupportDynamicSize, IViewSupportContentInset, IViewSupportPlacement, IViewSupportAlpha, IViewContainBackground, IViewContainSeparator {
    
    public typealias Item = any IView & IViewSupportPress & IViewSupportSelected
    
    public let body: BarView< Background, LayoutView< AnyLayout >, Separator >
    
    @MonadicField(default: EmptyView.self)
    public var background: Background {
        set { self.body.background = newValue }
        get { self.body.background }
    }
    
    @MonadicField(default: EmptyView.self)
    public var separator: Separator {
        set { self.body.separator = newValue }
        get { self.body.separator }
    }
    
    public var size: DynamicSize {
        set {
            self.body.width = newValue.width
            self._content.height = newValue.height
        }
        get {
            return .init(
                width: self.body.width,
                height: self._content.height
            )
        }
    }
    
    @MonadicField
    public var selected: Item? {
        willSet {
            guard self.selected !== newValue else { return }
            self.selected?.isSelected = false
        }
        didSet {
            guard self.selected !== oldValue else { return }
            self.selected?.isSelected = true
        }
    }
    
    public var items: [Item] {
        set {
            guard self._items.elementsEqual(newValue, by: { $0 === $1 }) == false else { return }
            self._unsubscribe(self._items)
            self._items = newValue
            self._subscribe(self._items)
            self._contentLayout.content = newValue.map({
                AnyViewLayout($0)
            })
        }
        get { return self._items }
    }
    
    private let _contentLayout = HSplitLayout()
        .spacing(Defaults.spacing)
    
    private let _content: LayoutView< AnyLayout >
    
    private var _items: [Item] = []
    
    public init(
        background: Background,
        separator: Separator
    ) {
        self._content = .init(self._contentLayout)
            .width(.fill)
        
        self.body = .init(background: background, content: self._content, separator: separator)
            .placement(Defaults.placement)
    }
    
}

private extension TabBarView {
    
    func _subscribe(_ item: Item) {
        item.onPress(self, { target, _ in target._onPress(item) })
    }
    
    func _subscribe< Sequence : Collection >(_ items: Sequence) where Sequence.Element == Item  {
        for item in items {
            self._subscribe(item)
        }
    }
    
    func _unsubscribe(_ item: Item) {
        item.onPress(remove: self)
    }
    
    func _unsubscribe< Sequence : Collection >(_ items: Sequence) where Sequence.Element == Item  {
        for item in items {
            self._unsubscribe(item)
        }
    }
    
    func _onPress(_ item: Item) {
        self.selected = item
    }
    
}

extension TabBarView : IViewSupportItems {
    
    public func index(`where` block: (Item) -> Bool) -> Int? {
        return self._items.firstIndex(where: block)
    }
    
    @discardableResult
    public func insert< Sequence : Collection >(_ items: Sequence, at index: Int) -> Self where Sequence.Element == Item {
        let safeIndex = max(0, min(index, self._items.count))
        self._subscribe(items)
        self._items.insert(contentsOf: items, at: safeIndex)
        self._contentLayout.insert(items.map({ AnyViewLayout($0) }), at: safeIndex)
        return self
    }
    
    @discardableResult
    public func delete(at index: Int) -> Self {
        guard index < self._items.count else {
            return self
        }
        self._unsubscribe(self._items[index])
        self._items.remove(at: index)
        self._contentLayout.delete(index)
        return self
    }
    
    @discardableResult
    public func delete(_ range: Range< Int >) -> Self {
        let safeRange = Range< Int >(uncheckedBounds: (
            lower: min(max(range.lowerBound, 0), self._items.count),
            upper: min(max(range.upperBound, 0), self._items.count)
        ))
        guard safeRange.isEmpty == false else {
            return self
        }
        self._unsubscribe(self._items[safeRange])
        self._items.removeSubrange(safeRange)
        self._contentLayout.delete(range)
        return self
    }
    
}

extension TabBarView : IViewSupportColor where Body : IViewSupportColor {
}
