//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics
import KindNumeric

public extension Matrix3 {
    
    @inlinable
    init(_ cgAffineTransform: CGAffineTransform) {
        self.init(
            .init(cgAffineTransform.a), .init(cgAffineTransform.b), .zero,
            .init(cgAffineTransform.c), .init(cgAffineTransform.d), .zero,
            .init(cgAffineTransform.tx), .init(cgAffineTransform.ty), .one
        )
    }
    
}

public extension Matrix3 {
    
    @inlinable
    var cgAffineTransform: CGAffineTransform {
        return CGAffineTransform(
            a: self.m11.cgFloat, b: self.m12.cgFloat,
            c: self.m21.cgFloat, d: self.m22.cgFloat,
            tx: self.m31.cgFloat, ty: self.m32.cgFloat
        )
        
    }
    
}

#endif
