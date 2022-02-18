//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol ISyncDataSource : IDataSource {
    
    associatedtype Result
    
    var result: Result? { get }
    var isSyncing: Bool { get }
    var isNeedSync: Bool { get }
    var syncAt: Date? { get }
    
    func setNeedSync(reset: Bool)
    func syncIfNeeded()
    
}

public extension ISyncDataSource {
    
    func setNeedSync(reset: Bool = false) {
        self.setNeedSync(reset: reset)
    }
    
}
