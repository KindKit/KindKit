//
//  KindKit
//

import Foundation

public protocol IDatabaseKeyPath {
    
    associatedtype DatabaseTableColumn : IDatabaseTableColumn

    var index: Database.Index { get }
    
}
