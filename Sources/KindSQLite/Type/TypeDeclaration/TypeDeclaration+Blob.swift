//
//  KindKit
//

import Foundation

public extension TypeDeclaration {
    
    struct Blob : ITypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "BLOB"
        }
        
        public static var typeDeclaration: String {
            return "BLOB NOT NULL"
        }
        
    }
    
}

extension Data : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Blob
    
}
