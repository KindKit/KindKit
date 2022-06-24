//
//  KindKitCore
//

import Foundation
import KindKitCore

public extension UserDefaults {
    
    func remove(forKey key: String) {
        self.removeObject(forKey: key)
    }
    
    func remove(forKeys keys: [String]) {
        for key in keys {
            self.removeObject(forKey: key)
        }
    }
    
}

public extension UserDefaults {
    
    func remove< Key: RawRepresentable >(
        forKey key: Key
    ) where Key.RawValue == String {
        self.remove(forKey: key.rawValue)
    }
    
    func remove< Key: RawRepresentable >(
        forKeys keys: [Key]
    ) where Key.RawValue == String {
        for key in keys {
            self.remove(forKey: key.rawValue)
        }
    }
    
    func remove< Key: RawRepresentable & CaseIterable >(
        forKeys keys: Key.Type
    ) where Key.RawValue == String {
        for key in keys.allCases {
            self.remove(forKey: key.rawValue)
        }
    }
    
}
