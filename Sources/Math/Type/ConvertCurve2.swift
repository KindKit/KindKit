//
//  KindKitMath
//

import Foundation

public struct ConvertCurve2< Curve: ICurve2 & Hashable > : Hashable {
    
    public let curve: Curve
    public let error: Curve.Value
    
    public init(
        curve: Curve,
        error: Curve.Value
    ) {
        self.curve = curve
        self.error = error
    }
    
}
