//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseEnum {
    
    associatedtype RealValue
    
    var realValue: Self.RealValue { get }
    
    init(realValue: Self.RealValue)
    
}
