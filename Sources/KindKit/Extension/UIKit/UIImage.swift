//
//  KindKit
//

#if os(iOS)

import UIKit

public typealias NativeImage = UIImage

public extension UIImage {
    
    func kk_compare(
        expected: UIImage,
        tolerance: CGFloat
    ) -> Bool {
        guard let origin = self.cgImage, let expected = expected.cgImage else { return false }
        return origin.kk_compare(expected: expected, tolerance: tolerance)
    }
    
}

#endif
