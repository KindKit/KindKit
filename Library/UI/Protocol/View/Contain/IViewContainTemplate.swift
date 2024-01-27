//
//  KindKit
//

public protocol IViewContainTemplate : AnyObject {
    
    associatedtype Template : ITemplate
    
    var template: Template { set get }
    
}

public extension IViewContainTemplate {
    
    @inlinable
    @discardableResult
    func template(_ value: Template) -> Self {
        self.template = value
        return self
    }
    
    @inlinable
    @discardableResult
    func template(on: () -> Template) -> Self {
        self.template = on()
        return self
    }

    @inlinable
    @discardableResult
    func template(on: (Self) -> Template) -> Self {
        self.template = on(self)
        return self
    }
    
}

public extension IViewContainTemplate where Self : IViewSupportContent, Content : ITemplate {
    
    var template: Content {
        set { self.content = newValue }
        get { self.content }
    }
    
}

public extension IViewContainTemplate where Self : CompositorTrait, Body : IViewContainTemplate {
    
    @inlinable
    var template: Body.Template {
        set { self.body.template = newValue }
        get { self.body.template }
    }
    
}
