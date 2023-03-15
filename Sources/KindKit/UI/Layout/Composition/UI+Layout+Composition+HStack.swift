//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    final class HStack {
        
        public var alignment: Alignment
        public var behaviour: Behaviour
        public var spacing: Double
        public var entities: [IUICompositionLayoutEntity]
        
        public init(
            alignment: Alignment,
            behaviour: Behaviour = [],
            spacing: Double = 0,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.alignment = alignment
            self.behaviour = behaviour
            self.spacing = spacing
            self.entities = entities
        }
        
    }
    
}

extension UI.Layout.Composition.HStack : IUICompositionLayoutEntity {
    
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

private extension UI.Layout.Composition.HStack {
    
    @inline(__always)
    func _sizePass(available: KindKit.Size) -> Pass {
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
            for entity in self.entities {
                let size = entity.size(available: .init(
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
            for entity in self.entities {
                let size = entity.size(available: .init(
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

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HStack {
    
    @inlinable
    static func hStack(
        alignment: UI.Layout.Composition.HStack.Alignment,
        behaviour: UI.Layout.Composition.HStack.Behaviour = [],
        spacing: Double = 0,
        entities: [IUICompositionLayoutEntity]
    ) -> Self {
        return .init(
            alignment: alignment,
            behaviour: behaviour,
            spacing: spacing,
            entities: entities
        )
    }
    
}
