//
//  KindKitJson
//

import Foundation
import KindKitCore

public typealias IJsonValueCoder = IJsonValueDecoder & IJsonValueEncoder

public protocol IJsonValueDecoder : IValueDecoder where StorageType == IJsonValue {
}

public protocol IJsonValueEncoder : IValueEncoder where StorageType == IJsonValue {
}
