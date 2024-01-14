//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class ZStackPart {
        
        public var items: [ILayoutPart]
        
        public init(
            _ items: [ILayoutPart]
        ) {
            self.items = items
        }
        
    }
    
}

extension CompositionLayout.ZStackPart : ILayoutPart {
    
    public func invalidate() {
        for item in self.items {
            item.invalidate()
        }
    }
    
    public func invalidate(_ view: IView) {
        for item in self.items {
            item.invalidate(view)
        }
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> Size {
        var maxSize = Size.zero
        for item in self.items {
            let size = item.size(available: bounds.size)
            maxSize = maxSize.max(size)
        }
        for item in self.items {
            item.layout(
                bounds: Rect(
                    topLeft: bounds.topLeft,
                    size: maxSize
                )
            )
        }
        return maxSize
    }
    
    public func size(available: Size) -> Size {
        var maxSize = Size.zero
        for item in self.items {
            let size = item.size(available: available)
            maxSize = maxSize.max(size)
        }
        return maxSize
    }
    
    public func views(bounds: Rect) -> [IView] {
        var views: [IView] = []
        for item in self.items {
            views.append(contentsOf: item.views(bounds: bounds))
        }
        return views
    }
    
}
