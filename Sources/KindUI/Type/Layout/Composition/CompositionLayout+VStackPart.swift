//
//  KindKit
//

import KindMath

extension CompositionLayout {
    
    public final class VStackPart {
        
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

extension CompositionLayout.VStackPart : ILayoutPart {
    
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
        case .left: self._layoutLeft(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .right: self._layoutRight(bounds: bounds, pass: pass)
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

private extension CompositionLayout.VStackPart {
    
    @inline(__always)
    func _sizePass(available: Size) -> Pass {
        var pass: Pass
        if self.behaviour.contains(.fit) == true {
            let width: Double
            if available.width.isInfinite == true {
                width = 0
            } else {
                width = available.width
            }
            pass = Pass(
                sizes: [],
                bounding: .init(
                    width: width,
                    height: 0
                )
            )
            for item in self.items {
                let size = item.size(available: .init(
                    width: available.width,
                    height: available.height - pass.bounding.height
                ))
                pass.sizes.append(size)
                if size.height > 0 {
                    pass.bounding.width = max(pass.bounding.width, size.width)
                    pass.bounding.height += size.height + self.spacing
                }
            }
        } else {
            pass = Pass(
                sizes: [],
                bounding: .zero
            )
            for item in self.items {
                let size = item.size(available: .init(
                    width: available.width,
                    height: .infinity
                ))
                pass.sizes.append(size)
                if size.height > 0 {
                    pass.bounding.width = max(pass.bounding.width, size.width)
                    pass.bounding.height += size.height + self.spacing
                }
            }
        }
        if pass.bounding.height > 0 {
            pass.bounding.height -= self.spacing
        }
        return pass
    }
    
    @inline(__always)
    func _layoutLeft(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(topLeft: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: Rect, pass: Pass) {
        var origin = bounds.top
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(top: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutRight(bounds: Rect, pass: Pass) {
        var origin = bounds.topRight
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(topRight: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, item) in self.items.enumerated() {
            let size = pass.sizes[index]
            item.layout(bounds: Rect(topLeft: origin, width: bounds.width, height: size.height))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
}
