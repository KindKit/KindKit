//
//  KindKit
//

public enum Status {
    
    case notSupported
    case notDetermined
    case authorized
    case denied
    
}

extension Status : Hashable {
}

extension Status : Equatable {
}

extension Status : Sendable {
}
