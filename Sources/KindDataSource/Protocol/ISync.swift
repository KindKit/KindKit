//
//  KindKit
//

import Foundation

public protocol ISync : IBase {
    
    var isSyncing: Bool { get }
    var isNeedSync: Bool { get }
    var syncAt: Date? { get }
    
    func setNeedSync(reset: Bool)
    func sync()
    
}

public extension ISync {
    
    func setNeedSync() {
        self.setNeedSync(reset: false)
    }
    
}
