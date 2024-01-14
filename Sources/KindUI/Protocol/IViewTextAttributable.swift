//
//  KindKit
//

import KindGraphics

public protocol IViewTextAttributable : IViewTextable {
    
    var text: NSAttributedString? { set get }
    var alignment: Text.Alignment? { set get }
    
}

public extension IViewTextAttributable where Self : IWidgetView, Body : IViewTextAttributable {
    
    @inlinable
    var text: NSAttributedString? {
        set { self.body.text = newValue }
        get { self.body.text }
    }
    
    @inlinable
    var alignment: Text.Alignment? {
        set { self.body.alignment = newValue }
        get { self.body.alignment }
    }
    
}

public extension IViewTextAttributable {
    
    @inlinable
    @discardableResult
    func text(_ value: NSAttributedString?) -> Self {
        self.text = value
        return self
    }
    
    @inlinable
    @discardableResult
    func text(_ value: () -> NSAttributedString?) -> Self {
        return self.text(value())
    }

    @inlinable
    @discardableResult
    func text(_ value: (Self) -> NSAttributedString?) -> Self {
        return self.text(value(self))
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: Text.Alignment?) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> Text.Alignment?) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> Text.Alignment?) -> Self {
        return self.alignment(value(self))
    }
    
}
