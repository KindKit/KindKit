//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct HSplitStack {
        
        public var alignment: Alignment
        public var spacing: Float
        public var entities: [ICompositionLayoutEntity]
        
        public init(
            alignment: Alignment = .fill,
            spacing: Float = 0,
            entities: [ICompositionLayoutEntity]
        ) {
            self.alignment = alignment
            self.spacing = spacing
            self.entities = entities
        }
        
    }
    
}

public extension CompositionLayout.HSplitStack {
    
    enum Alignment {
        case top
        case center
        case bottom
        case fill
    }
    
}

extension CompositionLayout.HSplitStack : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        for entity in self.entities {
            entity.invalidate(item: item)
        }
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        let pass = self._sizePass(available: bounds.size)
        switch self.alignment {
        case .top: self._layoutTop(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .bottom: self._layoutBottom(bounds: bounds, pass: pass)
        case .fill: self._layoutFill(bounds: bounds, pass: pass)
        }
        return pass.bounding
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        let pass = self._sizePass(available: available)
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

private extension CompositionLayout.HSplitStack {
    
    struct Pass {
        
        var sizes: [SizeFloat]
        var bounding: SizeFloat
        
    }
    
}

private extension CompositionLayout.HSplitStack {
    
    @inline(__always)
    func _availableSize(available: SizeFloat, entities: Int) -> SizeFloat {
        if entities > 1 {
            return SizeFloat(
                width: (available.width - (self.spacing * Float(entities - 1))) / Float(entities),
                height: available.height
            )
        } else if entities > 0 {
            return SizeFloat(
                width: available.width / Float(entities),
                height: available.height
            )
        }
        return .zero
    }
    
    @inline(__always)
    func _sizePass(available: SizeFloat) -> Pass {
        var pass = Pass(
            sizes: Array(
                repeating: .zero,
                count: self.entities.count
            ),
            bounding: .zero
        )
        if self.entities.isEmpty == false {
            var entityAvailableSize = self._availableSize(
                available: available,
                entities: pass.sizes.count
            )
            for (index, entity) in self.entities.enumerated() {
                pass.sizes[index] = entity.size(available: entityAvailableSize)
            }
            let numberOfValid = pass.sizes.count(where: { $0.width > 0 })
            if numberOfValid < self.entities.count {
                entityAvailableSize = self._availableSize(
                    available: available,
                    entities: numberOfValid
                )
                for (index, entity) in self.entities.enumerated() {
                    let size = pass.sizes[index]
                    guard size.width > 0 else { continue }
                    pass.sizes[index] = entity.size(available: entityAvailableSize)
                }
            }
            pass.bounding.width = available.width
            for (index, size) in pass.sizes.enumerated() {
                guard size.width > 0 else { continue }
                if size.width > 0 {
                    pass.sizes[index] = SizeFloat(width: entityAvailableSize.width, height: size.height)
                    pass.bounding.height = max(pass.bounding.height, size.height)
                }
            }
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
