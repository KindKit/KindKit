//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class HSplitStack {
        
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

extension UI.Layout.Composition.HSplitStack : IUICompositionLayoutEntity {
    
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
        case .top: self._layoutTop(bounds: bounds, pass: pass)
        case .center: self._layoutCenter(bounds: bounds, pass: pass)
        case .bottom: self._layoutBottom(bounds: bounds, pass: pass)
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

private extension UI.Layout.Composition.HSplitStack {
    
    @inline(__always)
    func _availableSize(available: Size, entities: Int) -> Size {
        if entities > 1 {
            return Size(
                width: (available.width - (self.spacing * Double(entities - 1))) / Double(entities),
                height: available.height
            )
        } else if entities > 0 {
            return Size(
                width: available.width / Double(entities),
                height: available.height
            )
        }
        return .zero
    }
    
    @inline(__always)
    func _sizePass(available: Size) -> Pass {
        var pass = Pass(
            sizes: Array(
                repeating: .zero,
                count: self.entities.count
            ),
            bounding: .zero
        )
        if self.entities.isEmpty == false {
            var entityAvailableSize: Size
            let numberOfValid: Int
            if available.height.isInfinite == false {
                entityAvailableSize = self._availableSize(
                    available: available,
                    entities: self.entities.count
                )
                for (index, entity) in self.entities.enumerated() {
                    pass.sizes[index] = entity.size(available: entityAvailableSize)
                }
                numberOfValid = pass.sizes.kk_count(where: { $0.width > 0 })
                if numberOfValid < self.entities.count {
                    entityAvailableSize = self._availableSize(
                        available: available,
                        entities: numberOfValid
                    )
                    for (index, entity) in self.entities.enumerated() {
                        guard pass.sizes[index].width > 0 else { continue }
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
                        width: max($0.width, $1.width),
                        height: available.height
                    )
                })
                numberOfValid = pass.sizes.kk_count(where: { $0.width > 0 })
            }
            if numberOfValid > 1 {
                pass.bounding.width = (entityAvailableSize.width * Double(numberOfValid)) + (self.spacing * Double(numberOfValid - 1))
            } else if numberOfValid > 0 {
                pass.bounding.width = entityAvailableSize.width
            }
            for (index, size) in pass.sizes.enumerated() {
                guard size.width > 0 else { continue }
                pass.sizes[index] = Size(width: entityAvailableSize.width, height: size.height)
                pass.bounding.height = max(pass.bounding.height, size.height)
            }
        }
        return pass
    }
    
    @inline(__always)
    func _layoutTop(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            entity.layout(bounds: Rect(topLeft: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: Rect, pass: Pass) {
        var origin = bounds.left
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            entity.layout(bounds: Rect(left: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutBottom(bounds: Rect, pass: Pass) {
        var origin = bounds.bottomLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            entity.layout(bounds: Rect(bottomLeft: origin, size: size))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            entity.layout(bounds: Rect(topLeft: origin, width: size.width, height: bounds.height))
            if size.width > 0 {
                origin.x += size.width + self.spacing
            }
        }
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HSplitStack {
    
    @inlinable
    static func hSplitStack(
        alignment: UI.Layout.Composition.HSplitStack.Alignment = .fill,
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
