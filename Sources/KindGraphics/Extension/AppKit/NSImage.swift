//
//  KindKit
//

#if os(macOS)

import AppKit

public extension NSImage {
    
    func kk_compare(
        expected: NSImage,
        tolerance: CGFloat
    ) -> Bool {
        guard let origin = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return false }
        guard let expected = expected.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return false }
        return origin.kk_compare(expected: expected, tolerance: tolerance)
    }
    
}

#endif
