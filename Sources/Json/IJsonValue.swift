//
//  KindKitJson
//

import Foundation

public protocol IJsonValue {
}

extension NSNull : IJsonValue {
}

extension NSString : IJsonValue {
}

extension NSNumber : IJsonValue {
}

extension NSArray : IJsonValue {
}

extension NSDictionary : IJsonValue {
}
