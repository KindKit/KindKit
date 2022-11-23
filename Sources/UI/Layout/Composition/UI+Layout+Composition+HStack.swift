//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition {
    
    struct HStack {
        
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
    public func layout(bounds: Rect) -> Size {
        let pass = self._sizePass(available: Size(
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
    
    public func size(available: Size) -> Size {
        let pass = self._sizePass(available: Size(
            width: .infinity,
            height: available.height
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

private extension UI.Layout.Composition.HStack {
    
    struct Pass {
        
        var sizes: [Size]
        var bounding: Size
        
    }
    
}

private extension UI.Layout.Composition.HStack {
    
    @inline(__always)
    func _sizePass(available: Size) -> Pass {
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
    func _layoutTop(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.width > 0 else { continue }
            entity.layout(bounds: Rect(topLeft: origin, size: size))
            origin.x += size.width + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutCenter(bounds: Rect, pass: Pass) {
        var origin = bounds.left
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.width > 0 else { continue }
            entity.layout(bounds: Rect(left: origin, size: size))
            origin.x += size.width + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutBottom(bounds: Rect, pass: Pass) {
        var origin = bounds.bottomLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.width > 0 else { continue }
            entity.layout(bounds: Rect(bottomLeft: origin, size: size))
            origin.x += size.width + self.spacing
        }
    }
    
    @inline(__always)
    func _layoutFill(bounds: Rect, pass: Pass) {
        var origin = bounds.topLeft
        for (index, entity) in self.entities.enumerated() {
            let size = pass.sizes[index]
            guard size.width > 0 else { continue }
            entity.layout(bounds: Rect(topLeft: origin, width: size.width, height: bounds.height))
            origin.x += size.width + self.spacing
        }
    }
    
}

public extension IUICompositionLayoutEntity where Self == UI.Layout.Composition.HStack {
    
    @inlinable
    static func hStack(
        alignment: UI.Layout.Composition.HStack.Alignment,
        spacing: Double = 0,
        entities: [IUICompositionLayoutEntity]
    ) -> UI.Layout.Composition.HStack {
        return .init(
            alignment: alignment,
            spacing: spacing,
            entities: entities
        )
    }
    
}
