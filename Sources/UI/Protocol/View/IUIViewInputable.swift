//
//  KindKit
//

import Foundation

public protocol IUIViewInputable : AnyObject {
    
    var isEditing: Bool { get }
    
    @discardableResult
    func startEditing() -> Self
    
    @discardableResult
    func endEditing() -> Self
    
}
