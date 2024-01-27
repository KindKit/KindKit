//
//  KindKit
//

import KindEvent

public protocol IViewSupportEdit : AnyObject {
    
    var shouldEditing: Bool { set get }
    
    var isEditing: Bool { set get }
    
}

public extension IViewSupportEdit where Self : IComposite, BodyType : IViewSupportEdit {
    
    @inlinable
    var shouldEditing: Bool {
        set { self.body.shouldEditing = newValue }
        get { self.body.shouldEditing }
    }
    
    @inlinable
    var isEditing: Bool {
        set { self.body.isEditing = newValue }
        get { self.body.isEditing }
    }
    
}

public extension IViewSupportEdit {
    
    @inlinable
    @discardableResult
    func shouldEditing(_ value: Bool) -> Self {
        self.shouldEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func shouldEditing(_ value: () -> Bool) -> Self {
        return self.shouldEditing(value())
    }

    @inlinable
    @discardableResult
    func shouldEditing(_ value: (Self) -> Bool) -> Self {
        return self.shouldEditing(value(self))
    }
    
    @inlinable
    @discardableResult
    func isEditing(_ value: Bool) -> Self {
        self.isEditing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isEditing(_ value: () -> Bool) -> Self {
        return self.isEditing(value())
    }

    @inlinable
    @discardableResult
    func isEditing(_ value: (Self) -> Bool) -> Self {
        return self.isEditing(value(self))
    }
    
}

public extension IViewSupportEdit {
    
    @inlinable
    var editing: Bool {
        set { self.isEditing = newValue }
        get { self.isEditing }
    }
    
    @inlinable
    @discardableResult
    func editing(_ value: Bool) -> Self {
        self.editing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func editing(_ value: () -> Bool) -> Self {
        return self.editing(value())
    }

    @inlinable
    @discardableResult
    func editing(_ value: (Self) -> Bool) -> Self {
        return self.editing(value(self))
    }
    
}

public extension IViewSupportEdit {
    
    @inlinable
    @discardableResult
    func startEditing() -> Self {
        return self.isEditing(true)
    }
    
    @inlinable
    @discardableResult
    func endEditing() -> Self {
        return self.isEditing(false)
    }
    
}
