//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct VStack {
        
        public var alignment: Alignment
        public var spacing: Float
        public var entities: [IUICompositionLayoutEntity]
        
        public init(
            alignment: Alignment,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.alignment = alignment
            self.spacing = 0
            self.entities = entities
        }
        
        public init< Spacing : BinaryInteger >(
            alignment: Alignment,
            spacing: Spacing,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.alignment = alignment
            self.spacing = Float(spacing)
            self.entities = entities
        }
        
        public init< Spacing : BinaryFloatingPoint >(
            alignment: Alignment,
            spacing: Spacing,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.alignment = alignment
            self.spacing = Float(spacing)
            self.entities = entities
        }
        
    }
    
}

private extension UI.Layout.Composition.VStack {
    
    struct Pass {
        
        var sizes: [SizeFloat]
        var bounding: SizeFloat
        
    }
    
}

extension UI.Layout.Composition.VStack : IUICompositionLayoutEntity {
    
    public func invalidate(item: UI.Layout.Item) {
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
    
    public func items(bounds: RectFloat) -> [UI.Layout.Item] {
        var items: [UI.Layout.Item] = []
        for entity in self.entities {
            items.append(contentsOf: entity.items(bounds: bounds))
        }
        return items
    }
    
}

private extension UI.Layout.Composition.VStack {
    
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

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VStack {
    
    @inlinable
    static func vStack(
        alignment: UI.Layout.Composition.VStack.Alignment,
        entities: [IUICompositionLayoutEntity]
    ) -> UI.Layout.Composition.VStack {
        return .init(
            alignment: alignment,
            entities: entities
        )
    }
    
    @inlinable
    static func vStack< Spacing : BinaryInteger >(
        alignment: UI.Layout.Composition.VStack.Alignment,
        spacing: Spacing,
        entities: [IUICompositionLayoutEntity]
    ) -> UI.Layout.Composition.VStack {
        return .init(
            alignment: alignment,
            spacing: spacing,
            entities: entities
        )
    }
    
    @inlinable
    static func vStack< Spacing : BinaryFloatingPoint >(
        alignment: UI.Layout.Composition.VStack.Alignment,
        spacing: Spacing,
        entities: [IUICompositionLayoutEntity]
    ) -> UI.Layout.Composition.VStack {
        return .init(
            alignment: alignment,
            spacing: spacing,
            entities: entities
        )
    }
    
}
