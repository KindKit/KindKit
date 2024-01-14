//
//  KindKit
//

import Foundation
#if canImport(CoreServices)
import CoreServices
#endif
#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

public struct MimeType {
    
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
}

public extension MimeType {
    
    @available(macOS 11.0, iOS 14.0, *)
    var uniformType: UTType? {
        return .init(mimeType: self.value)
    }
    
}

// MARK: Core

public extension MimeType {
}

// MARK: Images

public extension MimeType {
}

// MARK: Documents

public extension MimeType {
}
