//
//  KindKit
//

import Foundation

public final class Document {

    public let storage: UserDefaults

    public init(
        _ storage: UserDefaults
    ) {
        self.storage = storage
    }
    
}

extension Document : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension Document : Equatable {
    
    public static func == (lhs: Document, rhs: Document) -> Bool {
        return lhs === rhs
    }
    
}

extension Document : @unchecked Sendable {
}
