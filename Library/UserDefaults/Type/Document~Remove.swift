//
//  KindKit
//

import Foundation

public extension Document {
    
    @inlinable
    func remove(for key: String) {
        self.storage.removeObject(forKey: key)
    }
    
    @inlinable
    func remove(for keys: [String]) {
        for key in keys {
            self.storage.removeObject(forKey: key)
        }
    }
    
}

public extension Document {
    
    @inlinable
    func remove< Key : RawRepresentable >(
        for key: Key
    ) where Key.RawValue == String {
        self.remove(for: key.rawValue)
    }
    
    @inlinable
    func remove< Key : RawRepresentable >(
        for keys: [Key]
    ) where Key.RawValue == String {
        for key in keys {
            self.remove(for: key.rawValue)
        }
    }
    
}
