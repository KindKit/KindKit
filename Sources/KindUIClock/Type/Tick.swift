//
//  KindKit
//

import Foundation

public struct Tick : Equatable {
    
    public let duration: TimeInterval
    public var elapsed: TimeInterval
    
}

public extension Tick {
    
    @inlinable
    var remainder: TimeInterval {
        return self.duration - self.elapsed
    }
    
}
