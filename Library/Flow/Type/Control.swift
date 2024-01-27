//
//  KindKit
//

import KindCore

public enum Control {
    
    case completed
    case canceled
    
}

extension Control : Hashable {
}

extension Control : Equatable {
}

extension Control : Sendable {
}

public extension Control {
    
    @inlinable
    var isCompleted: Bool {
        return self == .completed
    }
    
    @inlinable
    var isCanceled: Bool {
        return self == .canceled
    }
    
}
