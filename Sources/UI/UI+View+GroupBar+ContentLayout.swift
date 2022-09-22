//
//  KindKit
//

import Foundation

extension UI.View.GroupBar {
    
    final class ContentLayout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var itemInset: InsetFloat = Inset(horizontal: 12, vertical: 0) {
            didSet { self.setNeedForceUpdate() }
        }
        var itemSpacing: Float = 4 {
            didSet { self.setNeedForceUpdate() }
        }
        var items: [UI.Layout.Item] = [] {
            didSet {
                self._cache = Array< SizeFloat? >(repeating: nil, count: self.items.count)
                self.setNeedForceUpdate()
            }
        }
        
        private var _cache: [SizeFloat?] = []

        init() {
        }
        
        func invalidate(item: UI.Layout.Item) {
            if let index = self.items.firstIndex(where: { $0 === item }) {
                self._cache.remove(at: index)
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            return UI.Layout.List.Helper.layout(
                bounds: bounds,
                direction: .horizontal,
                inset: self.itemInset,
                spacing: self.itemSpacing,
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
                inset: self.itemInset,
                spacing: self.itemSpacing,
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