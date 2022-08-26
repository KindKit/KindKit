//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public final class PagingLayout : ILayout {
    
    public unowned var delegate: ILayoutDelegate?
    public unowned var view: IView?
    public var direction: Direction {
        didSet(oldValue) {
            guard self.direction != oldValue else { return }
            self.setNeedForceUpdate()
        }
    }
    public var items: [LayoutItem] {
        set(value) {
            self._items = value
            self.setNeedForceUpdate()
        }
        get { return self._items }
    }
    public var views: [IView] {
        set(value) {
            self._items = value.compactMap({ return LayoutItem(view: $0) })
            self.setNeedForceUpdate()
        }
        get { return self._items.compactMap({ $0.view }) }
    }
    
    private var _items: [LayoutItem]

    public init(
        direction: Direction,
        items: [LayoutItem] = []
    ) {
        self.direction = direction
        self._items = items
    }

    public convenience init(
        direction: Direction,
        views: [IView]
    ) {
        self.init(
            direction: direction,
            items: views.compactMap({ return LayoutItem(view: $0) })
        )
    }
    
    public func contains(view: IView) -> Bool {
        guard let item = view.item else { return false }
        return self.contains(item: item)
    }
    
    public func contains(item: LayoutItem) -> Bool {
        return self.items.contains(where: { $0 === item })
    }
    
    public func index(view: IView) -> Int? {
        guard let item = view.item else { return nil }
        return self.index(item: item)
    }
    
    public func index(item: LayoutItem) -> Int? {
        return self.items.firstIndex(where: { $0 === item })
    }
    
    public func layout(bounds: RectFloat) -> SizeFloat {
        switch self.direction {
        case .horizontal:
            var origin = bounds.origin
            for item in self._items {
                item.frame = Rect(origin: origin, size: bounds.size)
                origin.x += bounds.width
            }
            return Size(
                width: bounds.width * Float(self._items.count),
                height: bounds.height
            )
        case .vertical:
            var origin = bounds.origin
            for item in self._items {
                item.frame = Rect(origin: origin, size: bounds.size)
                origin.y += bounds.height
            }
            return Size(
                width: bounds.width,
                height: bounds.height * Float(self._items.count)
            )
        }
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        switch self.direction {
        case .horizontal:
            return Size(
                width: available.width * Float(self._items.count),
                height: available.height
            )
        case .vertical:
            return Size(
                width: available.width,
                height: available.height * Float(self._items.count)
            )
        }
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        guard self._items.isEmpty == false else {
            return []
        }
        let sf, ef: Float
        switch self.direction {
        case .horizontal:
            sf = bounds.left.x / bounds.width
            ef = bounds.right.x / bounds.width
        case .vertical:
            sf = bounds.top.y / bounds.height
            ef = bounds.bottom.y / bounds.height
        }
        let s = max(0, Int(sf.roundDown))
        let e = min(Int(ef.roundUp), self._items.count)
        return Array(self._items[s..<e])
    }
    
}

public extension PagingLayout {
    
    enum Direction {
        case horizontal
        case vertical
    }
    
}
