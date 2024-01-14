//
//  KindKit
//

public protocol IViewInputable : IViewEditable {
    
    @discardableResult
    func startEditing() -> Self
    
    @discardableResult
    func endEditing() -> Self
    
}

public extension IViewInputable where Self : IWidgetView, Body : IViewInputable {
    
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
