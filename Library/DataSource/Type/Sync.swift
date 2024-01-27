//
//  KindKit
//

import Foundation

public protocol Sync : Base {
    
    var isSyncing: Bool { get }
    var isNeedSync: Bool { get }
    var syncAt: Date? { get }
    
    func setNeedSync(reset: Bool)
    func sync()
    
}

public extension Sync {
    
    func setNeedSync() {
        self.setNeedSync(reset: false)
    }
    
}
