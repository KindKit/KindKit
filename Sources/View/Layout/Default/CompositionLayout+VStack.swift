//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct VStack {
        
        public var alignment: Alignment
        public var spacing: Float
        public var entities: [ICompositionLayoutEntity]
        
        public init(
            alignment: Alignment,
            spacing: Float = 0,
            entities: [ICompositionLayoutEntity]
        ) {
            self.alignment = alignment
            self.spacing = spacing
            self.entities = entities
        }
        
    }
    
}

public extension CompositionLayout.VStack {
    
    enum Alignment {
        case left
        case center
        case right
        case fill
    }
    
}

private extension CompositionLayout.VStack {
    
    struct Pass {
        
        var sizes: [SizeFloat]
        var bounding: SizeFloat
        
    }
    
}

extension CompositionLayout.VStack : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        for entity in self.entities {
            entity.invalidate(item: item)
        }
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let pass = self._sizePass(available: SizeFloat(
            width: bounds.width,
            height: .infinity
        ))
        switch self.alignment {
        case .left: self._layoutLeft(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .right: self._layoutRight(bounds: bounds, pass: pass)
        case .fill: self._layoutFill(bounds: bounds, pass: pass)
        }
        return pass.bounding
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        let pass = self._sizePass(available: SizeFloat(
            width: available.width,
            height: .infinity
        ))
        return pass.bounding
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        var items: [LayoutItem] = []
        for entity in self.entities {
            items.append(contentsOf: entity.items(bounds: bounds))
        }
        return items
    }
    
}

private extension CompositionLayout.VStack {
    
    @inline(__always)
    func _sizePass(available: SizeFloat) -> Pass {
        var pass = Pass(
            sizes: [],
            bounding: .zero
        )
        for entity in self.entities {
            let size = entity.size(available: available)
            pass.sizes.append(size)
            if size.height > 0 {
                pass.bounding.width = max(pass.bounding.width, size.width)
                pass.bounding.height += size.height + self.spacing
            }
        }
        if pass.bounding.height > 0 {
            pass.bounding.height -= self.spacing
        }
        return pass
    }
    
    @inline(__always)
    func _layoutLeft(bounds: RectFloat, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.height > 0 else { continue }
            entity.layout(bounds: RectFloat(topLeft: origin, size: size))
            origin.y += size.height + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: RectFloat, pass: Pass) {
        var origin = bounds.top
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.height > 0 else { continue }
            entity.layout(bounds: RectFloat(top: origin, size: size))
            origin.y += size.height + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutRight(bounds: RectFloat, pass: Pass) {
        var origin = bounds.topRight
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.height > 0 else { continue }
            entity.layout(bounds: RectFloat(topRight: origin, size: size))
            origin.y += size.height + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: RectFloat, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.height > 0 else { continue }
            entity.layout(bounds: RectFloat(topLeft: origin, width: bounds.width, height: size.height))
            origin.y += size.height + self.spacing
        }
    }
    
}
