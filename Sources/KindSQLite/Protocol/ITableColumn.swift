//
//  KindKit
//

import Foundation

public protocol ITableColumn {
    
    associatedtype SQLiteTypeDeclaration : ITypeDeclaration
    associatedtype SQLiteValueCoder : IValueCoder
    
    var table: ITable { get }
    var name: String { get }

}
