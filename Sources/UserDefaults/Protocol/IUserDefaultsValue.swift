//
//  KindKitUserDefaults
//

import Foundation

public protocol IUserDefaultsValue {
}

extension NSNull : IUserDefaultsValue {
}

extension NSString : IUserDefaultsValue {
}

extension NSNumber : IUserDefaultsValue {
}
