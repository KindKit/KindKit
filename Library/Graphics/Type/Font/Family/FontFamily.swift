//
//  KindKit
//

public enum FontFamily {
    
    case system
    case custom(String)
    
}

extension FontFamily : Hashable {
}

extension FontFamily : Equatable {
}

extension FontFamily : Sendable {
}
