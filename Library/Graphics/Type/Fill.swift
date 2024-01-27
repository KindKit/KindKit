//
//  KindKit
//

public enum Fill {
    
    case color(Color)
    case pattern(Pattern)
    
}

extension Fill : Hashable {
}

extension Fill : Equatable {
}

extension Fill : Sendable {
}
