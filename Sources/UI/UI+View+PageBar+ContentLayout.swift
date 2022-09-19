//
//  KindKit
//

import Foundation

extension UI.View.PageBar {
    
    final class ContentLayout : IUILayout {
        
        enum IndicatorState {
            case empty
            case alias(current: UI.Layout.Item)
            case transition(current: UI.Layout.Item, next: UI.Layout.Item, progress: PercentFloat)
        }
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var leadingItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var trailingItem: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var indicatorItem: UI.Layout.Item {
            didSet { self.setNeedForceUpdate() }
        }
        var indicatorState: IndicatorState = .empty {
            didSet { self.setNeedUpdate() }
        }
        var itemInset: InsetFloat = InsetFloat(horizontal: 12, vertical: 0) {
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

        init(
            indicatorView: IUIView
        ) {
            self.indicatorItem = UI.Layout.Item(indicatorView)
        }
        
        func invalidate(item: UI.Layout.Item) {
            if let index = self.items.firstIndex(where: { $0 === item }) {
                self._cache[index] = nil
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let leadingSize: SizeFloat
            if let item = self.leadingItem {
                leadingSize = item.size(available: bounds.size)
                item.frame = RectFloat(
                    left: bounds.left,
                    size: leadingSize
                )
            } else {
                leadingSize = .zero
            }
            let trailingSize: SizeFloat
            if let item = self.trailingItem {
                trailingSize = item.size(available: bounds.size)
                item.frame = RectFloat(
                    right: bounds.right,
                    size: trailingSize
                )
            } else {
                trailingSize = .zero
            }
            let itemsSize = UI.Layout.List.Helper.layout(
                bounds: bounds.inset(InsetFloat(
                    top: 0,
                    left: leadingSize.width,
                    right: trailingSize.width,
                    bottom: 0
                )),
                direction: .horizontal,
                inset: self.itemInset,
                spacing: self.itemSpacing,
                maxSize: bounds.size.width,
                items: self.items,
                cache: &self._cache
            )
            return Size(
                width: leadingSize.width + itemsSize.width + trailingSize.width,
                height: max(leadingSize.height, itemsSize.height, trailingSize.height)
            )
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let leadingSize: SizeFloat
            if let item = self.leadingItem {
                leadingSize = item.size(available: available)
            } else {
                leadingSize = .zero
            }
            let trailingSize: SizeFloat
            if let item = self.trailingItem {
                trailingSize = item.size(available: available)
            } else {
                trailingSize = .zero
            }
            let itemsSize = UI.Layout.List.Helper.size(
                available: available.inset(InsetFloat(
                    top: 0,
                    left: leadingSize.width,
                    right: trailingSize.width,
                    bottom: 0
                )),
                direction: .horizontal,
                inset: self.itemInset,
                spacing: self.itemSpacing,
                maxSize: available.width,
                items: self.items
            )
            return Size(
                width: leadingSize.width + itemsSize.width + trailingSize.width,
                height: max(leadingSize.height, itemsSize.height, trailingSize.height)
            )
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items = self.visible(items: self.items, for: bounds)
            switch self.indicatorState {
            case .empty:
                break
            case .alias(let current):
                self.indicatorItem.frame = current.frame
                items.append(self.indicatorItem)
            case .transition(let current, let next, let progress):
                self.indicatorItem.frame = current.frame.lerp(next.frame, progress: progress)
                items.append(self.indicatorItem)
            }
            if let item = self.leadingItem {
                item.frame = RectFloat(
                    left: bounds.left,
                    size: item.frame.size
                )
                items.append(item)
            }
            if let item = self.trailingItem {
                item.frame = RectFloat(
                    right: bounds.right,
                    size: item.frame.size
                )
                items.append(item)
            }
            return items
        }
        
    }
    
}
