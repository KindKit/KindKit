//
//  KindKit
//

import PhotosUI

public extension PermissionRequest {
    
    enum Access {
        
        case addOnly
        case readWrite
        
    }
    
}

extension PermissionRequest.Access : Hashable {
}

extension PermissionRequest.Access : Equatable {
}

extension PermissionRequest.Access : Sendable {
}

extension PermissionRequest.Access {
    
    @available(macOS 11, iOS 14, *)
    var level: PHAccessLevel {
        switch self {
        case .addOnly: return .addOnly
        case .readWrite: return .readWrite
        }
    }
    
}
