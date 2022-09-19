//
//  KindKit
//

import Foundation

public extension Database {
    
    enum Location {
        
        case inMemory
        case temporary
        case uri(_ path: String)
        
    }
        
}

public extension Database.Location {
    
    @inlinable
    static func uri(filename: String) -> Self {
        return .uri(self.path(filename: filename))
    }
    
}

extension Database.Location {
    
    @inlinable
    static func path(filename: String) -> String {
        return "\(FileManager.userDocumentsPath)/\(filename).sqlite"
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
