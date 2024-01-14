//
//  KindKit
//

import Foundation

public protocol IValue {
}

extension NSNull : IValue {
}

extension NSString : IValue {
}

extension NSNumber : IValue {
}

extension NSArray : IValue {
}

extension NSDictionary : IValue {
}
