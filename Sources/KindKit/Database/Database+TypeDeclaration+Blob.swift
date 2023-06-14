//
//  KindKit
//

import Foundation

public extension Database.TypeDeclaration {
    
    struct Blob : IDatabaseTypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "BLOB"
        }
        
        public static var typeDeclaration: String {
            return "BLOB NOT NULL"
        }
        
    }
    
}

extension Data : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Blob
    
}
