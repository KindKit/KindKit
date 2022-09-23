//
//  KindKit
//

import Foundation

extension UI.View.PageBar {
    
    final class ContentLayout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var leading: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var trailing: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate() }
        }
        var indicator: UI.Layout.Item {
            didSet { self.setNeedForceUpdate() }
        }
        var indicatorState: IndicatorState = .empty {
            didSet { self.setNeedUpdate() }
        }
        var items: [UI.Layout.Item] = [] {
            didSet {
                self._cache = Array< SizeFloat? >(repeating: nil, count: self.items.count)
                self.setNeedForceUpdate()
            }
        }
        var itemsInset: InsetFloat = InsetFloat(horizontal: 12, vertical: 0) {
            didSet { self.setNeedForceUpdate() }
        }
        var itemsSpacing: Float = 4 {
            didSet { self.setNeedForceUpdate() }
        }
        
        private var _cache: [SizeFloat?] = []

        init(
            indicator: IUIView
        ) {
            self.indicator = UI.Layout.Item(indicator)
        }
        
        func invalidate(item: UI.Layout.Item) {
            if let index = self.items.firstIndex(where: { $0 === item }) {
                self._cache[index] = nil
            }
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let leadingSize: SizeFloat
            if let item = self.leading {
                leadingSize = item.size(available: bounds.size)
                item.frame = RectFloat(
                    left: bounds.left,
                    size: leadingSize
                )
            } else {
                leadingSize = .zero
            }
            let trailingSize: SizeFloat
            if let item = self.trailing {
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
                inset: self.itemsInset,
                spacing: self.itemsSpacing,
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
            if let item = self.leading {
                leadingSize = item.size(available: available)
            } else {
                leadingSize = .zero
            }
            let trailingSize: SizeFloat
            if let item = self.trailing {
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
                inset: self.itemsInset,
                spacing: self.itemsSpacing,
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
                self.indicator.frame = current.frame
                items.append(self.indicator)
            case .transition(let current, let next, let progress):
                self.indicator.frame = current.frame.lerp(next.frame, progress: progress)
                items.append(self.indicator)
            }
            if let item = self.leading {
                item.frame = RectFloat(
                    left: bounds.left,
                    size: item.frame.size
                )
                items.append(item)
            }
            if let item = self.trailing {
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
