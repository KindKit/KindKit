//
//  KindKit
//

import KindEvent

public protocol IViewClickable : AnyObject {
    
    var shouldClick: [Mouse.Button] { set get }
    
    var onClick: Signal< Void, Mouse.Click > { get }
    
}

public extension IViewClickable where Self : IComposite, BodyType : IViewClickable {
    
    @inlinable
    var shouldClick: [Mouse.Button] {
        set { self.body.shouldClick = newValue }
        get { self.body.shouldClick }
    }
    
    @inlinable
    var onClick: Signal< Void, Mouse.Click > {
        self.body.onClick
    }
    
}

public extension IViewClickable {
    
    func shouldClick(button: Mouse.Button) -> Bool {
        return self.shouldClick.contains(button)
    }
    
}

public extension IViewClickable {
    
    @inlinable
    @discardableResult
    func shouldClick(_ value: [Mouse.Button]) -> Self {
        self.shouldClick = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldClick(_ value: () -> [Mouse.Button]) -> Self {
        return self.shouldClick(value())
    }

    @inlinable
    @discardableResult
    func shouldClick(_ value: (Self) -> [Mouse.Button]) -> Self {
        return self.shouldClick(value(self))
    }
    
}

public extension IViewClickable {
    
    @inlinable
    @discardableResult
    func onClick(_ closure: @escaping (Mouse.Click) -> Void) -> Self {
        self.onClick.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onClick(_ closure: @escaping (Self, Mouse.Click) -> Void) -> Self {
        self.onClick.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onClick< TargetType : AnyObject >(_ target: TargetType, _ closure: @escaping (TargetType, Mouse.Click) -> Void) -> Self {
        self.onClick.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onClick(remove target: AnyObject) -> Self {
        self.onClick.remove(target)
        return self
    }
    
}
