//
//  KindKit
//

import Foundation

public extension TypeDeclaration {
    
    struct Text : ITypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "TEXT"
        }
        
        public static var typeDeclaration: String {
            return "TEXT NOT NULL"
        }
        
    }
    
}

extension String : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Text
    
}

extension SemaVersion : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Text
    
}

extension URL : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Text
    
}
