//
//  KindKit
//

#if canImport(QuartzCore)

import QuartzCore

public extension Matrix3 {
    
    @inlinable
    var caTransform3D: CATransform3D {
        return CATransform3DMakeAffineTransform(self.cgAffineTransform)
    }
    
    init(_ caTransform3D: CATransform3D) {
        self.init(CATransform3DGetAffineTransform(caTransform3D))
    }
}

#endif
