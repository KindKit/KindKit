//
//  KindKit
//

import Foundation

public extension Document {
    
    @inlinable
    func remove(_ keys: [String]) {
        for key in keys {
            self.remove(key)
        }
    }
    
}

public extension Document {
    
    @inlinable
    func remove< Key : RawRepresentable >(
        forKey key: Key
    ) where Key.RawValue == String {
        self.remove(key.rawValue)
    }
    
    @inlinable
    func remove< Key : RawRepresentable >(
        forKeys keys: [Key]
    ) where Key.RawValue == String {
        for key in keys {
            self.remove(key.rawValue)
        }
    }
    
    @inlinable
    func remove< Key : RawRepresentable & CaseIterable >(
        forKeys keys: Key.Type
    ) where Key.RawValue == String {
        for key in keys.allCases {
            self.remove(key.rawValue)
        }
    }
    
}
