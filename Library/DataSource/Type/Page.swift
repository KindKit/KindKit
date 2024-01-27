//
//  KindKit
//

import Foundation

public protocol Page : Base where Success : Sequence {
    
    var isLoading: Bool { get }
    var isLoadedFirstPage: Bool { get }
    var canMore: Bool { get }

    func load(reload: Bool)
    
}

public extension Page {
    
    var isLoadedFirstPage: Bool {
        return self.result != nil
    }
    
    func load() {
        self.load(reload: false)
    }
    
}
