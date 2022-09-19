//
//  KindKit
//

import Foundation

public protocol ISyncDataSource : IDataSource {
    
    var isSyncing: Bool { get }
    var isNeedSync: Bool { get }
    var syncAt: Date? { get }
    
    func setNeedSync(reset: Bool)
    func syncIfNeeded()
    
}

public extension ISyncDataSource {
    
    func setNeedSync() {
        self.setNeedSync(reset: false)
    }
    
}
