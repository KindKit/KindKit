//
//  KindKit
//

public enum Level {
    
    case debug
    case info
    case error
    
}

extension Level : Hashable {
}

extension Level : Equatable {
}

extension Level : Sendable {
}
