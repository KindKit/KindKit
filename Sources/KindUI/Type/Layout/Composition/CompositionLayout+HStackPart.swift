//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class HStackPart {
        
        public var alignment: Alignment
        public var behaviour: Behaviour
        public var spacing: Double
        public var items: [ILayoutPart]
        
        public init(
            alignment: Alignment,
            behaviour: Behaviour = [],
            spacing: Double = 0,
            items: [ILayoutPart]
        ) {
            self.alignment = alignment
            self.behaviour = behaviour
            self.spacing = spacing
            self.items = items
        }
        
    }
    
}

extension CompositionLayout.HStackPart : ILayoutPart {
    
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
        let pass = self._sizePass(available: bounds.size)
        switch self.alignment {
        case .top: self._layoutTop(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .bottom: self._layoutBottom(bounds: bounds, pass: pass)
        case .fill: self._layoutFill(bounds: bounds, pass: pass)
        }
        return pass.bounding
    }
    
    public func size(available: Size) -> Size {
        let pass = self._sizePass(available: available)
        return pass.bounding
    }
    
    public func views(bounds: Rect) -> [IView] {
        var views: [IView] = []
        for item in self.items {
            views.append(contentsOf: item.views(bounds: bounds))
        }
        return views
    }
    
}

private extension CompositionLayout.HStackPart {
    
    @inline(__always)
    func _sizePass(available: Size) -> Pass {
        var pass: Pass
        if self.behaviour.contains(.fit) == true {
            let height: Double
            if available.height.isInfinite == true {
                height = 0
            } else {
                height = available.height
            }
            pass = Pass(
                sizes: [],
                bounding: .init(
                    width: 0,
                    height: height
                )
            )
            for item in self.items {
                let size = item.size(available: .init(
                    width: available.width - pass.bounding.width,
                    height: available.height
                ))
                pass.sizes.append(size)
                if size.width > 0 {
                    pass.bounding.width += size.width + self.spacing
                    pass.bounding.height = max(pass.bounding.height, size.height)
                }
            }
        } else {
            pass = Pass(
                sizes: [],
                bounding: .zero
            )
            for item in self.items {
                let size = item.size(available: .init(
                    width: .infinity,
                    height: available.height
                ))
                pass.sizes.append(size)
                if size.width > 0 {
                    pass.bounding.width += size.width + self.spacing
                    pass.bounding.height = max(pass.bounding.height, size.height)
                }
            }
        }
        if pass.bounding.width > 0 {
            pass.bounding.width -= self.spacing
        }
        return pass
    }
    
    @inline(__always)
    func _layoutTop(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(topLeft: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: Rect, pass: Pass) {
        var origin = bounds.left
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(left: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutBottom(bounds: Rect, pass: Pass) {
        var origin = bounds.bottomLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(bottomLeft: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(topLeft: origin, width: size.width, height: bounds.height))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
}
