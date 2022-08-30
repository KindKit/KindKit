//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.Result {
    
    struct Insert {
        
        public let lastRowId: Database.RowId
        public let numberOfInserted: Database.Count
        
    }
    
}
