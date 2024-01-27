//
//  KindKit
//

import Foundation

public protocol IKeyPath {
    
    associatedtype SQLiteTableColumn : ITableColumn

    var index: Index { get }
    
}
