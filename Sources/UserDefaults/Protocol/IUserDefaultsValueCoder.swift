//
//  KindKitUserDefaults
//

import Foundation
import KindKitCore

public typealias IUserDefaultsValueCoder = IUserDefaultsValueDecoder & IUserDefaultsValueEncoder

public protocol IUserDefaultsValueDecoder : IValueDecoder where StorageType == IUserDefaultsValue {
}

public protocol IUserDefaultsValueEncoder : IValueEncoder where StorageType == IUserDefaultsValue {
}
