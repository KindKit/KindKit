//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct HStack {
        
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

public extension CompositionLayout.HStack {
    
    enum Alignment {
        case top
        case center
        case bottom
        case fill
    }
    
}

extension CompositionLayout.HStack : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        for entity in self.entities {
            entity.invalidate(item: item)
        }
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let pass = self._sizePass(available: SizeFloat(
            width: .infinity,
            height: bounds.height
        ))
        switch self.alignment {
        case .top: self._layoutTop(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .bottom: self._layoutBottom(bounds: bounds, pass: pass)
        case .fill: self._layoutFill(bounds: bounds, pass: pass)
        }
        return pass.bounding
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        let pass = self._sizePass(available: SizeFloat(
            width: .infinity,
            height: available.height
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

private extension CompositionLayout.HStack {
    
    struct Pass {
        
        var sizes: [SizeFloat]
        var bounding: SizeFloat
        
    }
    
}

private extension CompositionLayout.HStack {
    
    @inline(__always)
    func _sizePass(available: SizeFloat) -> Pass {
        var pass = Pass(
            sizes: [],
            bounding: .zero
        )
        for entity in self.entities {
            let size = entity.size(available: available)
            pass.sizes.append(size)
            if size.width > 0 {
                pass.bounding.width += size.width + self.spacing
                pass.bounding.height = max(pass.bounding.height, size.height)
            }
        }
        if pass.bounding.width > 0 {
            pass.bounding.width -= self.spacing
        }
        return pass
    }
    
    @inline(__always)
    func _layoutTop(bounds: RectFloat, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.width > 0 else { continue }
            entity.layout(bounds: RectFloat(topLeft: origin, size: size))
            origin.x += size.width + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: RectFloat, pass: Pass) {
        var origin = bounds.left
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.width > 0 else { continue }
            entity.layout(bounds: RectFloat(left: origin, size: size))
            origin.x += size.width + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutBottom(bounds: RectFloat, pass: Pass) {
        var origin = bounds.bottomLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.width > 0 else { continue }
            entity.layout(bounds: RectFloat(bottomLeft: origin, size: size))
            origin.x += size.width + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: RectFloat, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.width > 0 else { continue }
            entity.layout(bounds: RectFloat(topLeft: origin, width: size.width, height: bounds.height))
            origin.x += size.width + self.spacing
        }
    }
    
}
