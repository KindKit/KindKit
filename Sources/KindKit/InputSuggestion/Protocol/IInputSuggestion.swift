//
//  KindKit
//

import Foundation

public protocol IInputSuggestion : AnyObject {
    
    func autoComplete(_ text: String) -> String?
    func variants(_ text: String) -> [String]
    
}
