//
//  KindKit
//

#if canImport(QuartzCore)

import QuartzCore
import KindNumeric

public extension Matrix3 {
    
    @inlinable
    init(_ caTransform3D: CATransform3D) {
        self.init(CATransform3DGetAffineTransform(caTransform3D))
    }
    
}

public extension Matrix3 {
    
    @inlinable
    var caTransform3D: CATransform3D {
        return CATransform3DMakeAffineTransform(self.cgAffineTransform)

    }
    
}

#endif
