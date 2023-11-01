//
//  KindKit
//

import Foundation

public protocol IUIViewInputable : IUIViewEditable {
    
    @discardableResult
    func startEditing() -> Self
    
    @discardableResult
    func endEditing() -> Self
    
}

public extension IUIViewInputable where Self : IUIWidgetView, Body : IUIViewInputable {
    
    @discardableResult
    func startEditing() -> Self {
        self.body.startEditing()
        return self
    }
    
    @discardableResult
    func endEditing() -> Self {
        self.body.endEditing()
        return self
    }
    
}
