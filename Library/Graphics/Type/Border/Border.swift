//
//  KindKit
//

import KindMonadicMacro

@Monadic
public struct Border {

    @MonadicField
    public let width: Coordinate
    
    @MonadicField
    public let color: Color
    
    public init(
        width: Coordinate,
        color: Color
    ) {
        self.width = width
        self.color = color
    }
    
}

extension Border : Hashable {
}

extension Border : Equatable {
}

extension Border : Sendable {
}
