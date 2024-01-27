//
//  KindKit
//

import KindUI
import KindMonadicMacro

fileprivate enum Defaults {
    
    static let placement = Placement.bottom
    static let inset = Inset(horizontal: 8, vertical: 4)
    static let spacing = Double(4)
    
}

@KindMonadic
public final class TabBarView<
    BackgroundType : IView,
    SeparatorType : IView
> : IComposite, IView {
    
    public typealias ItemType = any IView & IViewSupportPress & IViewSupportHighlighted & IViewSupportSelected
    
    public let body: BarView< BackgroundType, LayoutView< AnyLayout >, SeparatorType >
    
    @KindMonadicProperty(default: EmptyView.self)
    public var background: BackgroundType {
        set { self.body.background = newValue }
        get { self.body.background }
    }
    
    @KindMonadicProperty(default: EmptyView.self)
    public var separator: SeparatorType {
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
    
    @KindMonadicProperty
    public var selected: ItemType? {
        willSet {
            guard self.selected !== newValue else { return }
            self.selected?.isSelected = false
        }
        didSet {
            guard self.selected !== oldValue else { return }
            self.selected?.isSelected = true
        }
    }
    
    public var items: [ItemType] {
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
    
    private var _items: [ItemType] = []
    
    public init(
        background: BackgroundType,
        separator: SeparatorType
    ) {
        self._content = .init(self._contentLayout)
            .width(.fill)
        
        self.body = .init(background: background, content: self._content, separator: separator)
            .placement(Defaults.placement)
            .height(.fit)
    }
    
}

private extension TabBarView {
    
    func _subscribe(_ item: ItemType) {
        item.onPress(self, { target, _ in target._onPress(item) })
    }
    
    func _subscribe< SequenceType : Collection >(_ items: SequenceType) where SequenceType.Element == ItemType  {
        for item in items {
            self._subscribe(item)
        }
    }
    
    func _unsubscribe(_ item: ItemType) {
        item.onPress(remove: self)
    }
    
    func _unsubscribe< SequenceType : Collection >(_ items: SequenceType) where SequenceType.Element == ItemType  {
        for item in items {
            self._unsubscribe(item)
        }
    }
    
    func _onPress(_ item: ItemType) {
        self.selected = item
    }
    
}

extension TabBarView : IViewSupportDynamicSize {
}

extension TabBarView : IViewSupportColor where BodyType : IViewSupportColor {
}

extension TabBarView : IViewSupportAlpha {
}

extension TabBarView : IViewSupportPlacement {
}

extension TabBarView : IViewSupportInset {
}

extension TabBarView : IViewSupportBackground {
}

extension TabBarView : IViewSupportItems {
    
    public func index(`where` block: (ItemType) -> Bool) -> Int? {
        return self._items.firstIndex(where: block)
    }
    
    @discardableResult
    public func insert< SequenceType : Collection >(_ items: SequenceType, at index: Int) -> Self where SequenceType.Element == ItemType {
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

extension TabBarView : IViewSupportSeparator {
}
