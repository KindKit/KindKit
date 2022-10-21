//
//  KindKit
//

import Foundation

public extension UI.Size {
    
    struct Static : Equatable {
        
        public var width: Dimension?
        public var height: Dimension?
        
        public init(
            width: Dimension?,
            height: Dimension?
        ) {
            self.width = width
            self.height = height
        }
        
    }
    
}

public extension UI.Size.Static {
    
    @inlinable
    func apply(
        available: SizeFloat,
        aspectRatio: Float?
    ) -> SizeFloat {
        if let aspectRatio = aspectRatio {
            if let width = self.width {
                let w = width.apply(available: available.width)
                if w > .leastNonzeroMagnitude {
                    return Size(width: w, height: w / aspectRatio)
                }
            } else if let height = self.height {
                let h = height.apply(available: available.height)
                if h > .leastNonzeroMagnitude {
                    return Size(width: h * aspectRatio, height: h)
                }
            }
            return .zero
        }
        return self.apply(available: available)
    }
    
    @inlinable
    func apply(
        available: SizeFloat
    ) -> SizeFloat {
        let w: Float
        if let width = self.width {
            w = width.apply(available: available.width)
        } else {
            w = 0
        }
        let h: Float
        if let height = self.height {
            h = height.apply(available: available.height)
        } else {
            h = 0
        }
        return Size(width: w, height: h)
    }
    
}
