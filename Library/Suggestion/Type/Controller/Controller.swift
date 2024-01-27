//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public protocol Controller : AnyObject {
    
    associatedtype Item : KindSuggestion.Item
    
    var isStarting: Bool { get }
    
    var items: [Item] { get }
    
    @MonadicSignal
    var onItems: Signal< Void, [Item] > { get }
    
    func start()
    func update(_ input: String)
    func stop()

}
