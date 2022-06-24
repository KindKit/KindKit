//
//  KindKitJson
//

import Foundation
import KindKitCore

public typealias IJsonValueCoder = IJsonValueDecoder & IJsonValueEncoder

public protocol IJsonValueDecoder : IValueDecoder where Storage == IJsonValue {
}

public protocol IJsonValueEncoder : IValueEncoder where Storage == IJsonValue {
}
