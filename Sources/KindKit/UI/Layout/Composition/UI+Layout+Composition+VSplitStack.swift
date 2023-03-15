//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class VSplitStack {
        
        public var alignment: Alignment
        public var spacing: Double
        public var entities: [IUICompositionLayoutEntity]
        
        public init(
            alignment: Alignment = .fill,
            spacing: Double = 0,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.alignment = alignment
            self.spacing = spacing
            self.entities = entities
        }
        
    }
    
}

extension UI.Layout.Composition.VSplitStack : IUICompositionLayoutEntity {
    
    public func invalidate() {
        for entity in self.entities {
            entity.invalidate()
        }
    }
    
    public func invalidate(_ view: IUIView) {
        for entity in self.entities {
            entity.invalidate(view)
        }
    }
    
    @discardableResult
    public func layout(bounds: Rect) -> KindKit.Size {
        let pass = self._sizePass(available: bounds.size)
        switch self.alignment {
        case .left: self._layoutLeft(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .right: self._layoutRight(bounds: bounds, pass: pass)
        case .fill: self._layoutFill(bounds: bounds, pass: pass)
        }
        return pass.bounding
    }
    
    public func size(available: KindKit.Size) -> KindKit.Size {
        let pass = self._sizePass(available: available)
        return pass.bounding
    }
    
    public func views(bounds: Rect) -> [IUIView] {
        var views: [IUIView] = []
        for entity in self.entities {
            views.append(contentsOf: entity.views(bounds: bounds))
        }
        return views
    }
    
}

private extension UI.Layout.Composition.VSplitStack {
    
    @inline(__always)
    func _availableSize(available: KindKit.Size, entities: Int) -> KindKit.Size {
        if entities > 1 {
            return .init(
                width: available.width,
                height: (available.height - (self.spacing * Double(entities - 1))) / Double(entities)
            )
        } else if entities > 0 {
            return .init(
                width: available.width,
                height: available.height / Double(entities)
            )
        }
        return .zero
    }
    
    @inline(__always)
    func _sizePass(available: KindKit.Size) -> Pass {
        var pass = Pass(
            sizes: Array(
                repeating: .zero,
                count: self.entities.count
            ),
            bounding: .zero
        )
        if self.entities.isEmpty == false {
            var entityAvailableSize: KindKit.Size
            let numberOfValid: Int
            if available.width.isInfinite == false {
                entityAvailableSize = self._availableSize(
                    available: available,
                    entities: self.entities.count
                )
                for (index, entity) in self.entities.enumerated() {
                    pass.sizes[index] = entity.size(available: entityAvailableSize)
                }
                numberOfValid = pass.sizes.kk_count(where: { $0.height > 0 })
                if numberOfValid < self.entities.count {
                    entityAvailableSize = self._availableSize(
                        available: available,
                        entities: numberOfValid
                    )
                    for (index, entity) in self.entities.enumerated() {
                        guard pass.sizes[index].height > 0 else { continue }
                        pass.sizes[index] = entity.size(available: entityAvailableSize)
                    }
                }
            } else {
                for (index, entity) in self.entities.enumerated() {
                    pass.sizes[index] = entity.size(available: available)
                }
                entityAvailableSize = pass.sizes.kk_reduce({
                    return .zero
                }, {
                    return $0
                }, {
                    return .init(
                        width: available.width,
                        height: max($0.height, $1.height)
                    )
                })
                numberOfValid = pass.sizes.kk_count(where: { $0.height > 0 })
            }
            if numberOfValid > 1 {
                pass.bounding.height = (entityAvailableSize.height * Double(numberOfValid)) + (self.spacing * Double(numberOfValid - 1))
            } else if numberOfValid > 0 {
                pass.bounding.height = entityAvailableSize.height
            }
            for (index, size) in pass.sizes.enumerated() {
                guard size.height > 0 else { continue }
                pass.sizes[index] = .init(width: size.width, height: entityAvailableSize.height)
                pass.bounding.width = max(pass.bounding.width, size.width)
            }
        }
        return pass
    }
    
    @inline(__always)
    func _layoutLeft(bounds: Rect, pass: Pass) {
        var origin = bounds.left
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            entity.layout(bounds: Rect(left: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: Rect, pass: Pass) {
        var origin = bounds.center
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            entity.layout(bounds: Rect(center: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutRight(bounds: Rect, pass: Pass) {
        var origin = bounds.right
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            entity.layout(bounds: Rect(right: origin, size: size))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            entity.layout(bounds: Rect(topLeft: origin, width: bounds.width, height: size.height))
            if size.height > 0 {
                origin.y += size.height + self.spacing
            }
        }
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VSplitStack {
    
    @inlinable
    static func vSplitStack(
        alignment: UI.Layout.Composition.VSplitStack.Alignment = .fill,
        spacing: Double = 0,
        entities: [IUICompositionLayoutEntity]
    ) -> Self {
        return .init(
            alignment: alignment,
            spacing: spacing,
            entities: entities
        )
    }
    
}
