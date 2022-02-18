//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol IPageDataSource : IDataSource where Result : RangeReplaceableCollection {
    
    associatedtype Result
    
    var result: Result? { get }
    var isLoading: Bool { get }
    var isLoadedFirstPage: Bool { get }
    var canMore: Bool { get }

    func load(reload: Bool)
    
}

public extension IPageDataSource {
    
    var isLoadedFirstPage: Bool {
        return self.result != nil
    }
    
    func load(reload: Bool = false) {
        self.load(reload: reload)
    }
    
}
