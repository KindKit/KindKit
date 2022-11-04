//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class Paging : IUILayout {
        
        public weak var delegate: IUILayoutDelegate?
        public weak var view: IUIView?
        public var direction: Direction {
            didSet {
                guard self.direction != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var items: [UI.Layout.Item] {
            set {
                guard self._items != newValue else { return }
                self._items = newValue
                self.setNeedForceUpdate()
            }
            get { self._items }
        }
        public var views: [IUIView] {
            set {
                self._items = newValue.map({ UI.Layout.Item($0) })
                self.setNeedForceUpdate()
            }
            get { self._items.map({ $0.view }) }
        }
        
        private var _items: [UI.Layout.Item]

        public init(
            direction: Direction,
            items: [UI.Layout.Item] = []
        ) {
            self.direction = direction
            self._items = items
        }

        @inlinable
        public convenience init(
            direction: Direction,
            views: [IUIView]
        ) {
            self.init(
                direction: direction,
                items: views.map({ UI.Layout.Item($0) })
            )
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
            guard self._items.isEmpty == false && available.isZero == false else {
                return .zero
            }
            switch self.direction {
            case .horizontal:
                var accumulate: Float = 0
                for index in 0 ..< self._items.count {
                    let item = self._items[index]
                    let itemSize = item.size(available: available)
                    accumulate = max(accumulate, itemSize.height)
                }
                return Size(
                    width: available.width * Float(self._items.count),
                    height: accumulate
                )
            case .vertical:
                var accumulate: Float = 0
                for index in 0 ..< self._items.count {
                    let item = self._items[index]
                    let itemSize = item.size(available: available)
                    accumulate = max(accumulate, itemSize.width)
                }
                return Size(
                    width: accumulate,
                    height: available.height * Float(self._items.count)
                )
            }
        }
        
        public func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard self._items.isEmpty == false && bounds.size.isZero == false else {
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
    
}

public extension UI.Layout.Paging {
    
    @inlinable
    func contains(view: IUIView) -> Bool {
        guard let item = view.appearedItem else { return false }
        return self.contains(item: item)
    }
    
    @inlinable
    func contains(item: UI.Layout.Item) -> Bool {
        return self.items.contains(item)
    }
    
    @inlinable
    func index(view: IUIView) -> Int? {
        guard let item = view.appearedItem else { return nil }
        return self.index(item: item)
    }
    
    @inlinable
    func index(item: UI.Layout.Item) -> Int? {
        return self.items.firstIndex(of: item)
    }
    
}

public extension IUILayout where Self == UI.Layout.Paging {
    
    @inlinable
    static func paging(
        direction: UI.Layout.Paging.Direction,
        items: [UI.Layout.Item] = []
    ) -> UI.Layout.Paging {
        return .init(
            direction: direction,
            items: items
        )
    }
    
    @inlinable
    static func paging(
        direction: UI.Layout.Paging.Direction,
        views: [IUIView] = []
    ) -> UI.Layout.Paging {
        return .init(
            direction: direction,
            views: views
        )
    }
    
}
