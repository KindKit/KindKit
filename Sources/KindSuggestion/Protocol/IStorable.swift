//
//  KindKit
//

import KindEvent

public protocol IStorable : AnyObject {
    
    associatedtype StoreType: Equatable
    
    var store: [StoreType] { get }
    var onStore: Signal< Void, [StoreType] > { get }

}
