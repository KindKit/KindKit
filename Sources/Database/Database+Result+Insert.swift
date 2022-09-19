//
//  KindKit
//

import Foundation

public extension Database.Result {
    
    struct Insert {
        
        public let lastRowId: Database.RowId
        public let numberOfInserted: Database.Count
        
    }
    
}
