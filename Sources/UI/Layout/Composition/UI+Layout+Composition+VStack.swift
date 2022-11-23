//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct VStack {
        
        public var alignment: Alignment
        public var spacing: Double
        public var entities: [IUICompositionLayoutEntity]
        
        public init(
            alignment: Alignment,
            spacing: Double = 0,
            entities: [IUICompositionLayoutEntity]
        ) {
            self.alignment = alignment
            self.spacing = spacing
            self.entities = entities
        }
        
    }
    
}

private extension UI.Layout.Composition.VStack {
    
    struct Pass {
        
        var sizes: [Size]
        var bounding: Size
        
    }
    
}

extension UI.Layout.Composition.VStack : IUICompositionLayoutEntity {
    
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
    public func layout(bounds: Rect) -> Size {
        let pass = self._sizePass(available: Size(
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
    
    public func size(available: Size) -> Size {
        let pass = self._sizePass(available: Size(
            width: available.width,
            height: .infinity
        ))
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

private extension UI.Layout.Composition.VStack {
    
    @inline(__always)
    func _sizePass(available: Size) -> Pass {
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
    func _layoutLeft(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.height > 0 else { continue }
            entity.layout(bounds: Rect(topLeft: origin, size: size))
            origin.y += size.height + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: Rect, pass: Pass) {
        var origin = bounds.top
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.height > 0 else { continue }
            entity.layout(bounds: Rect(top: origin, size: size))
            origin.y += size.height + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutRight(bounds: Rect, pass: Pass) {
        var origin = bounds.topRight
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.height > 0 else { continue }
            entity.layout(bounds: Rect(topRight: origin, size: size))
            origin.y += size.height + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.height > 0 else { continue }
            entity.layout(bounds: Rect(topLeft: origin, width: bounds.width, height: size.height))
            origin.y += size.height + self.spacing
        }
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.VStack {
    
    @inlinable
    static func vStack(
        alignment: UI.Layout.Composition.VStack.Alignment,
        spacing: Double = 0,
        entities: [IUICompositionLayoutEntity]
    ) -> UI.Layout.Composition.VStack {
        return .init(
            alignment: alignment,
            spacing: spacing,
            entities: entities
        )
    }
    
}
