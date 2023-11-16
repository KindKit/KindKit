//
//  KindKit
//

import Foundation

public protocol IInputSuggestion : AnyObject {
    
    var onVariants: Signal.Args< Void, [String] > { get }
    
    func begin()
    func end()
    
    func autoComplete(_ text: String) -> String?
    func variants(_ text: String)

}
