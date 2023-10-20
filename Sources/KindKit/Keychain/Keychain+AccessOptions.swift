//
//  KindKit
//

import Foundation
import Security

public extension Keychain {
    
    enum AccessOptions {
        
        case whenUnlocked
        case whenUnlockedThisDeviceOnly
        case afterFirstUnlock
        case afterFirstUnlockThisDeviceOnly
        case whenPasscodeSetThisDeviceOnly

        public static var defaultOption: AccessOptions {
            return .whenUnlocked
        }

        public var value: String {
            switch self {
            case .whenUnlocked: return kSecAttrAccessibleWhenUnlocked as String
            case .whenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
            case .afterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock as String
            case .afterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String
            case .whenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String
            }
        }
    }
    
}
