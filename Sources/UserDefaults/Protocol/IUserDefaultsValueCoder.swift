//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public typealias IUserDefaultsValueCoder = IUserDefaultsValueDecoder & IUserDefaultsValueEncoder

public protocol IUserDefaultsValueDecoder : IValueDecoder where Storage == IUserDefaultsValue {
}

public protocol IUserDefaultsValueEncoder : IValueEncoder where Storage == IUserDefaultsValue {
}
