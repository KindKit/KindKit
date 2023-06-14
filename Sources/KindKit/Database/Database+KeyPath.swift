//
//  KindKit
//

import Foundation

public extension Database {
    
    struct KeyPath< Column : IDatabaseTableColumn > : IDatabaseKeyPath {
        
        public typealias DatabaseTableColumn = Column
        
        public let index: Database.Index
        
        init(_ index: Database.Index) {
            self.index = index
        }
        
    }

}
