//
//  KindKit
//

import Foundation
import PhotosUI

public extension Permission.PhotoLibrary {
    
    enum Access {
        
        case addOnly
        case readWrite
        
    }
    
}

extension Permission.PhotoLibrary.Access {
    
    @available(macOS 11, iOS 14, *)
    var level: PHAccessLevel {
        switch self {
        case .addOnly: return .addOnly
        case .readWrite: return .readWrite
        }
    }
    
}
