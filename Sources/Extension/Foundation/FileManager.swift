//
//  KindKit
//

import Foundation

public extension FileManager {
    
    @inlinable
    static var kk_userDocumentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    @inlinable
    static var kk_userDocumentsPath: String {
        return Self.kk_userDocumentsUrl.path
    }
    
}
