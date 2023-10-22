//
//  KindKit
//

import Foundation

public extension TimeInterval {
    
    @inlinable
    static func kk_delta(start: DispatchTime, end: DispatchTime) -> Self {
        return TimeInterval(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
    }
    
}
