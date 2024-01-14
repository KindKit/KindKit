//
//  KindKit
//

import Foundation

public enum Location {
    
    case inMemory
    case temporary
    case uri(String)
    
}

public extension Location {
    
    @inlinable
    static func uri(filename: String) -> Self {
        return .uri(self.path(filename: filename))
    }
    
}

extension Location {
    
    @inlinable
    static func path(filename: String) -> String {
        return "\(FileManager.kk_userDocumentsPath)/\(filename).sqlite"
    }
    
    @inlinable
    var query: String {
        switch self {
        case .inMemory: return ":memory:"
        case .temporary: return ""
        case .uri(let path): return path
        }
    }
    
}
