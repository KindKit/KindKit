//
//  KindKit
//

import KindMath

extension PageBarView {
    
    final class ContentLayout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var leading: IView? {
            didSet { self.setNeedUpdate() }
        }
        var trailing: IView? {
            didSet { self.setNeedUpdate() }
        }
        var indicator: IView? {
            didSet { self.setNeedUpdate() }
        }
        var indicatorState: IndicatorState = .empty {
            didSet { self.setNeedUpdate() }
        }
        var items: [IView] = [] {
            didSet {
                self._cache = Array< Size? >(repeating: nil, count: self.items.count)
                self.setNeedUpdate()
            }
        }
        var itemsInset: Inset = Inset(horizontal: 12, vertical: 0) {
            didSet { self.setNeedUpdate() }
        }
        var itemsSpacing: Double = 4 {
            didSet { self.setNeedUpdate() }
        }
        
        private var _cache: [Size?] = []

        init() {
        }
        
        public func invalidate() {
            for index in self._cache.startIndex ..< self._cache.endIndex {
                self._cache[index] = nil
            }
        }
        
        func invalidate(_ view: IView) {
            if let index = self.items.firstIndex(where: { view === $0 }) {
                self._cache[index] = nil
            }
        }
        
        func layout(bounds: Rect) -> Size {
            let leadingSize: Size
            if let item = self.leading {
                leadingSize = item.size(available: bounds.size)
                item.frame = Rect(
                    left: bounds.left,
                    size: leadingSize
                )
            } else {
                leadingSize = .zero
            }
            let trailingSize: Size
            if let item = self.trailing {
                trailingSize = item.size(available: bounds.size)
                item.frame = Rect(
                    right: bounds.right,
                    size: trailingSize
                )
            } else {
                trailingSize = .zero
            }
            let itemsSize = ListLayout.Helper.layout(
                bounds: bounds.inset(Inset(
                    top: 0,
                    left: leadingSize.width,
                    right: trailingSize.width,
                    bottom: 0
                )),
                direction: .horizontal,
                inset: self.itemsInset,
                spacing: self.itemsSpacing,
                maxSize: bounds.size.width,
                views: self.items,
                cache: &self._cache
            )
            return Size(
                width: leadingSize.width + itemsSize.width + trailingSize.width,
                height: max(leadingSize.height, itemsSize.height, trailingSize.height)
            )
        }
        
        func size(available: Size) -> Size {
            let leadingSize: Size
            if let item = self.leading {
                leadingSize = item.size(available: available)
            } else {
                leadingSize = .zero
            }
            let trailingSize: Size
            if let item = self.trailing {
                trailingSize = item.size(available: available)
            } else {
                trailingSize = .zero
            }
            let itemsSize = ListLayout.Helper.size(
                available: available.inset(Inset(
                    top: 0,
                    left: leadingSize.width,
                    right: trailingSize.width,
                    bottom: 0
                )),
                direction: .horizontal,
                inset: self.itemsInset,
                spacing: self.itemsSpacing,
                maxSize: available.width,
                views: self.items
            )
            return Size(
                width: leadingSize.width + itemsSize.width + trailingSize.width,
                height: max(leadingSize.height, itemsSize.height, trailingSize.height)
            )
        }
        
        func views(bounds: Rect) -> [IView] {
            var items = self.visible(views: self.items, for: bounds)
            if let indicator = self.indicator {
                switch self.indicatorState {
                case .empty:
                    break
                case .alias(let current):
                    indicator.frame = current.frame
                    items.append(indicator)
                case .transition(let current, let next, let progress):
                    indicator.frame = current.frame.lerp(next.frame, progress: progress)
                    items.append(indicator)
                }
            }
            if let item = self.leading {
                item.frame = Rect(
                    left: bounds.left,
                    size: item.frame.size
                )
                items.append(item)
            }
            if let item = self.trailing {
                item.frame = Rect(
                    right: bounds.right,
                    size: item.frame.size
                )
                items.append(item)
            }
            return items
        }
        
    }
    
}
