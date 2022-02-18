//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public extension CompositionLayout {
    
    struct ZStack {
        
        public var mode: Mode
        public var entities: [ICompositionLayoutEntity]
        
        public init(
            mode: Mode = [],
            entities: [ICompositionLayoutEntity]
        ) {
            self.mode = mode
            self.entities = entities
        }
        
    }
    
}

public extension CompositionLayout.ZStack {
    
    struct Mode : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let horizontal = Mode(rawValue: 1 << 0)
        public static let vertical = Mode(rawValue: 1 << 1)
        
    }
    
}

extension CompositionLayout.ZStack : ICompositionLayoutEntity {
    
    public func invalidate(item: LayoutItem) {
        for entity in self.entities {
            entity.invalidate(item: item)
        }
    }
    
    @discardableResult
    public func layout(bounds: RectFloat) -> SizeFloat {
        var maxSize = SizeFloat.zero
        if self.mode.contains(.horizontal) == true {
            maxSize.width = bounds.width
        }
        if self.mode.contains(.vertical) == true {
            maxSize.height = bounds.height
        }
        for entity in self.entities {
            let size = entity.size(available: bounds.size)
            maxSize = maxSize.max(size)
        }
        for entity in self.entities {
            entity.layout(
                bounds: RectFloat(
                    topLeft: bounds.topLeft,
                    size: maxSize
                )
            )
        }
        return maxSize
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        var maxSize = SizeFloat.zero
        if self.mode.contains(.horizontal) == true {
            maxSize.width = available.width
        }
        if self.mode.contains(.vertical) == true {
            maxSize.height = available.height
        }
        for entity in self.entities {
            let size = entity.size(available: available)
            maxSize = maxSize.max(size)
        }
        return maxSize
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        var items: [LayoutItem] = []
        for entity in self.entities {
            items.append(contentsOf: entity.items(bounds: bounds))
        }
        return items
    }
    
}
