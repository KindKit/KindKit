//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class Paging : IUILayout {
        
        public unowned var delegate: IUILayoutDelegate?
        public unowned var view: IUIView?
        public var direction: Direction {
            didSet(oldValue) {
                guard self.direction != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var items: [UI.Layout.Item] {
            set(value) {
                self._items = value
                self.setNeedForceUpdate()
            }
            get { return self._items }
        }
        public var views: [IUIView] {
            set(value) {
                self._items = value.compactMap({ return UI.Layout.Item($0) })
                self.setNeedForceUpdate()
            }
            get { return self._items.compactMap({ $0.view }) }
        }
        
        private var _items: [UI.Layout.Item]

        public init(
            direction: Direction,
            items: [UI.Layout.Item] = []
        ) {
            self.direction = direction
            self._items = items
        }

        public convenience init(
            direction: Direction,
            views: [IUIView]
        ) {
            self.init(
                direction: direction,
                items: views.compactMap({ return UI.Layout.Item($0) })
            )
        }
        
        public func contains(view: IUIView) -> Bool {
            guard let item = view.item else { return false }
            return self.contains(item: item)
        }
        
        public func contains(item: UI.Layout.Item) -> Bool {
            return self.items.contains(where: { $0 === item })
        }
        
        public func index(view: IUIView) -> Int? {
            guard let item = view.item else { return nil }
            return self.index(item: item)
        }
        
        public func index(item: UI.Layout.Item) -> Int? {
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
        
        public func items(bounds: RectFloat) -> [UI.Layout.Item] {
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
