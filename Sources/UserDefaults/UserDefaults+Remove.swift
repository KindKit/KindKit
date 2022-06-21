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
    
    func remove< KeyType: RawRepresentable >(
        forKey key: KeyType
    ) where KeyType.RawValue == String {
        self.remove(forKey: key.rawValue)
    }
    
    func remove< KeyType: RawRepresentable >(
        forKeys keys: [KeyType]
    ) where KeyType.RawValue == String {
        for key in keys {
            self.remove(forKey: key.rawValue)
        }
    }
    
    func remove< KeyType: RawRepresentable & CaseIterable >(
        forKeys keys: KeyType.Type
    ) where KeyType.RawValue == String {
        for key in keys.allCases {
            self.remove(forKey: key.rawValue)
        }
    }
    
}
