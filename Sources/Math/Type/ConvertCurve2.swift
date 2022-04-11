//
//  KindKitMath
//

import Foundation

public struct ConvertCurve2< CurveType: ICurve2 & Hashable > : Hashable {
    
    public let curve: CurveType
    public let error: CurveType.ValueType
    
    public init(
        curve: CurveType,
        error: CurveType.ValueType
    ) {
        self.curve = curve
        self.error = error
    }
    
}
