//
//  KindKit
//

import Foundation

public protocol IInputSuggestionStorable : AnyObject {
    
    associatedtype StoreType: Equatable
    
    var store: [StoreType] { get }
    var onStore: Signal.Args< Void, [StoreType] > { get }

}
