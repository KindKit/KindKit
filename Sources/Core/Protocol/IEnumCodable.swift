//
//  KindKitCode
//

import Foundation

public typealias IEnumCodable = IEnumDecodable & IEnumEncodable

public protocol IEnumDecodable : RawRepresentable {
    
    associatedtype RealValue
    
    var realValue: RealValue { get }
    
}

public protocol IEnumEncodable : RawRepresentable {
    
    associatedtype RealValue
    
    init(realValue: RealValue)
    
}
