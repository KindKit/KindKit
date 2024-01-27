//
//  KindKit
//

import Foundation
import KindEvent
import KindText

public protocol IViewSupportText : AnyObject {
    
    var style: Style { set get }
    var text: Text { set get }
    var numberOfLines: UInt { set get }
    
    var onTap: Signal< Void, URL > { get }
    
}

public extension IViewSupportText where Self : IComposite, BodyType : IViewSupportText {
    
    @inlinable
    var style: Style {
        set { self.body.style = newValue }
        get { self.body.style }
    }
    
    @inlinable
    var text: Text {
        set { self.body.text = newValue }
        get { self.body.text }
    }
    
    @inlinable
    var numberOfLines: UInt {
        set { self.body.numberOfLines = newValue }
        get { self.body.numberOfLines }
    }
    
    @inlinable
    var onTap: Signal< Void, URL > {
        self.body.onTap
    }
    
}

public extension IViewSupportText {
    
    @inlinable
    @discardableResult
    func style(_ value: Style) -> Self {
        self.style = value
        return self
    }
    
    @inlinable
    @discardableResult
    func style(_ value: () -> Style) -> Self {
        return self.style(value())
    }

    @inlinable
    @discardableResult
    func style(_ value: (Self) -> Style) -> Self {
        return self.style(value(self))
    }
    
    @inlinable
    @discardableResult
    func text(_ value: Text) -> Self {
        self.text = value
        return self
    }
    
    @inlinable
    @discardableResult
    func text(_ value: () -> Text) -> Self {
        return self.text(value())
    }

    @inlinable
    @discardableResult
    func text(_ value: (Self) -> Text) -> Self {
        return self.text(value(self))
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

public extension IViewSupportText {
    
    @inlinable
    @discardableResult
    func onTap(_ closure: @escaping (URL) -> Void) -> Self {
        self.onTap.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap(_ closure: @escaping (Self, URL) -> Void) -> Self {
        self.onTap.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, URL) -> Void) -> Self {
        self.onTap.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTap(remove target: AnyObject) -> Self {
        self.onTap.remove(target)
        return self
    }
    
}
