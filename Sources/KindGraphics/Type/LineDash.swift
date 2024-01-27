//
//  KindKit
//

import KindMonadicMacro

@KindMonadic
public struct LineDash : Equatable {
    
    @KindMonadicProperty
    public let phase: Double
    
    @KindMonadicProperty
    public let lengths: [Double]
    
    public init(
        phase: Double,
        lengths: [Double]
    ) {
        self.phase = phase
        self.lengths = lengths
    }
    
}
