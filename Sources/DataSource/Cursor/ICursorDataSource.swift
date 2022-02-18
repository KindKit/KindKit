//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol ICursorDataSource : IPageDataSource {
    
    associatedtype Cursor
    
    var cursor: Cursor? { get }
    
}
