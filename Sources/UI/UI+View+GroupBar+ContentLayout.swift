//
//  KindKit
//

import Foundation

extension UI.View.GroupBar {
    
    final class ContentLayout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var items: [UI.Layout.Item] = [] {
            didSet {
                self._cache = Array< SizeFloat? >(repeating: nil, count: self.items.count)
                self.setNeedForceUpdate()
            }
        }
        var itemsInset: InsetFloat = Inset(horizontal: 12, vertical: 0) {
            didSet { self.setNeedForceUpdate() }
        }
        var itemsSpacing: Float = 4 {
            didSet { self.setNeedForceUpdate() }
        }
        
        private var _cache: [SizeFloat?] = []

        init() {
        }
        
        public func invalidate() {
            for index in self._cache.startIndex ..< self._cache.endIndex {
                self._cache[index] = nil
            }
        }
        
        func invalidate(item: UI.Layout.Item) {
            if let index = self.items.firstIndex(of: item) {
                self._cache[index] = nil
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            return UI.Layout.List.Helper.layout(
                bounds: bounds,
                direction: .horizontal,
                inset: self.itemsInset,
                spacing: self.itemsSpacing,
                minSize: bounds.size.width / Float(self.items.count),
                maxSize: bounds.size.width,
                items: self.items,
                cache: &self._cache
            )
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return UI.Layout.List.Helper.size(
                available: available,
                direction: .horizontal,
                inset: self.itemsInset,
                spacing: self.itemsSpacing,
                minSize: available.width / Float(self.items.count),
                maxSize: available.width,
                items: self.items
            )
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            return self.visible(items: self.items, for: bounds)
        }
        
    }
    
}
