//
//  KindKit
//

import KindMonadicMacro

@Monadic
public struct LineDash {
    
    @MonadicField
    public let phase: Coordinate
    
    @MonadicField
    public let lengths: [Coordinate]
    
    public init(
        phase: Coordinate,
        lengths: [Coordinate]
    ) {
        self.phase = phase
        self.lengths = lengths
    }
    
}

extension LineDash : Hashable {
}

extension LineDash : Equatable {
}

extension LineDash : Sendable {
}
