//
//  KindKitMath
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Matrix3 {
    
    @inlinable
    var cgAffineTransform: CGAffineTransform {
        return CGAffineTransform(
            a: self.m11.cgFloat, b: self.m12.cgFloat,
            c: self.m21.cgFloat, d: self.m22.cgFloat,
            tx: self.m31.cgFloat, ty: self.m32.cgFloat
        )
    }
    
    @inlinable
    init(_ cgAffineTransform: CGAffineTransform) {
        self.init(
            ValueType(cgAffineTransform.a), ValueType(cgAffineTransform.b), 0,
            ValueType(cgAffineTransform.c), ValueType(cgAffineTransform.d), 0,
            ValueType(cgAffineTransform.tx), ValueType(cgAffineTransform.ty), 1
        )
    }
}

#endif
