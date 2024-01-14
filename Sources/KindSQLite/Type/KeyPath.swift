//
//  KindKit
//

public struct KeyPath< Column : ITableColumn > : IKeyPath {
    
    public typealias SQLiteTableColumn = Column
    
    public let index: Index
    
    init(_ index: Index) {
        self.index = index
    }
    
}
