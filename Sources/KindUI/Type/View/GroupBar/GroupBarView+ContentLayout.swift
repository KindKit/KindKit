//
//  KindKit
//

import KindMath

extension GroupBarView {
    
    final class ContentLayout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
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
            return ListLayout.Helper.layout(
                bounds: bounds,
                direction: .horizontal,
                inset: self.itemsInset,
                spacing: self.itemsSpacing,
                minSize: bounds.size.width / Double(self.items.count),
                maxSize: bounds.size.width,
                views: self.items,
                cache: &self._cache
            )
        }
        
        func size(available: Size) -> Size {
            return ListLayout.Helper.size(
                available: available,
                direction: .horizontal,
                inset: self.itemsInset,
                spacing: self.itemsSpacing,
                minSize: available.width / Double(self.items.count),
                maxSize: available.width,
                views: self.items
            )
        }
        
        func views(bounds: Rect) -> [IView] {
            return self.visible(views: self.items, for: bounds)
        }
        
    }
    
}
