//
//  KindKit
//

import Foundation

public extension Database.TypeDeclaration {
    
    struct Text : IDatabaseTypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "TEXT"
        }
        
        public static var typeDeclaration: String {
            return "TEXT NOT NULL"
        }
        
    }
    
}

extension String : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Text
    
}

extension SemaVersion : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Text
    
}

extension URL : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Text
    
}
