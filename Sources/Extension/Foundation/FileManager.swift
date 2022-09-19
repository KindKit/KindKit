//
//  KindKit
//

import Foundation

public extension FileManager {
    
    @inlinable
    static var userDocumentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    @inlinable
    static var userDocumentsPath: String {
        return self.userDocumentsUrl.path
    }
    
}

public extension FileManager {
    
    @inlinable
    func documentDirectory() throws -> URL {
        return try self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    @inlinable
    func documentDirectory() throws -> String {
        return try self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).path
    }
    
}
