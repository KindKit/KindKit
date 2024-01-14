//
//  KindKit
//

import KindEvent

public protocol IEntity : AnyObject {
    
    var onVariants: Signal< Void, [String] > { get }
    
    func begin()
    func end()
    
    func autoComplete(_ text: String) -> String?
    func variants(_ text: String)

}
