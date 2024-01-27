//
//  KindKit
//

public struct ConvertCurve2< Curve : Curve2Trait > {
    
    public let curve: Curve
    public let error: Distance
    
    public init(
        curve: Curve,
        error: Distance
    ) {
        self.curve = curve
        self.error = error
    }
    
}
