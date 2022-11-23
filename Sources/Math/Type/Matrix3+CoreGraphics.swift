//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Matrix3 {
    
    @inlinable
    var cgAffineTransform: CGAffineTransform {
        return CGAffineTransform(
            a: CGFloat(self.m11), b: CGFloat(self.m12),
            c: CGFloat(self.m21), d: CGFloat(self.m22),
            tx: CGFloat(self.m31), ty: CGFloat(self.m32)
        )
    }
    
    init(_ cgAffineTransform: CGAffineTransform) {
        self.init(
            Double(cgAffineTransform.a), Double(cgAffineTransform.b), 0,
            Double(cgAffineTransform.c), Double(cgAffineTransform.d), 0,
            Double(cgAffineTransform.tx), Double(cgAffineTransform.ty), 1
        )
    }
}

#endif
