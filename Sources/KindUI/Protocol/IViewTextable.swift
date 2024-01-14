//
//  KindKit
//

import KindGraphics

public protocol IViewTextable : AnyObject {
    
    var lineBreak: Text.LineBreak { set get }
    var numberOfLines: UInt { set get }
    
}

public extension IViewTextable where Self : IWidgetView, Body : IViewTextable {
    
    @inlinable
    var lineBreak: Text.LineBreak {
        set { self.body.lineBreak = newValue }
        get { self.body.lineBreak }
    }
    
    @inlinable
    var numberOfLines: UInt {
        set { self.body.numberOfLines = newValue }
        get { self.body.numberOfLines }
    }
    
}

public extension IViewTextable {
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: Text.LineBreak) -> Self {
        self.lineBreak = value
        return self
    }
    
    @inlinable
    @discardableResult
    func lineBreak(_ value: () -> Text.LineBreak) -> Self {
        return self.lineBreak(value())
    }

    @inlinable
    @discardableResult
    func lineBreak(_ value: (Self) -> Text.LineBreak) -> Self {
        return self.lineBreak(value(self))
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: UInt) -> Self {
        self.numberOfLines = value
        return self
    }
    
    @inlinable
    @discardableResult
    func numberOfLines(_ value: () -> UInt) -> Self {
        return self.numberOfLines(value())
    }

    @inlinable
    @discardableResult
    func numberOfLines(_ value: (Self) -> UInt) -> Self {
        return self.numberOfLines(value(self))
    }
    
}
