//
//  KindKit
//

public struct Text : Equatable {
    
    public let parts: [Text.Part]
    
    public init(
        _ parts: [Text.Part] = []
    ) {
        self.parts = parts
    }
    
}

public extension Text {
    
    @inlinable
    static func text(
        _ parts: [Text.Part] = []
    ) -> Self {
        return .init(parts)
    }
    
}
