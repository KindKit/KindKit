//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension CATransaction {
    
    @inlinable
    class func kk_withoutActions(_ closure: () -> Void) {
        Self.begin()
        Self.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        closure()
        Self.commit()
    }
    
}
