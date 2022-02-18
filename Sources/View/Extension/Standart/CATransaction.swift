//
//  KindKitView
//

#if os(OSX)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension CATransaction {
    
    @inlinable
    class func withoutActions(_ closure: () -> Void) {
        Self.begin()
        Self.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        closure()
        Self.commit()
    }
    
}
