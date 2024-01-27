//
//  KindKit
//

import Foundation

public extension Document {
    
    @inlinable
    func remove(in keys: [String]) {
        for key in keys {
            self.remove(in: key)
        }
    }
    
    @inlinable
    func remove< Key : RawRepresentable >(
        in key: Key
    ) where Key.RawValue == String {
        self.remove(in: key.rawValue)
    }
    
    @inlinable
    func remove< Key : RawRepresentable >(
        in keys: [Key]
    ) where Key.RawValue == String {
        for key in keys {
            self.remove(in: key.rawValue)
        }
    }
    
    @inlinable
    func remove< Key : RawRepresentable & CaseIterable >(
        in keys: Key.Type
    ) where Key.RawValue == String {
        for key in keys.allCases {
            self.remove(in: key.rawValue)
        }
    }
    
}
