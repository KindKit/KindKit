//
//  KindKit
//

import Foundation

public struct ConvertCurve2< Curve : ICurve2 & Hashable > : Hashable {
    
    public let curve: Curve
    public let error: Double
    
    public init(
        curve: Curve,
        error: Double
    ) {
        self.curve = curve
        self.error = error
    }
    
}
