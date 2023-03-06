//
//  KindKit
//

import Foundation

public protocol IPageDataSource : IDataSource where Success : Sequence {
    
    var isLoading: Bool { get }
    var isLoadedFirstPage: Bool { get }
    var canMore: Bool { get }

    func load(reload: Bool)
    
}

public extension IPageDataSource {
    
    var isLoadedFirstPage: Bool {
        return self.result != nil
    }
    
    func load() {
        self.load(reload: false)
    }
    
}
