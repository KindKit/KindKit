//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IInputView : IView {
    
    var isEditing: Bool { get }
    
    @discardableResult
    func startEditing() -> Self
    
    @discardableResult
    func endEditing() -> Self
    
}
