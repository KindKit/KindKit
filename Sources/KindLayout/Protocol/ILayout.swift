//
//  KindKit
//

import KindMath

public protocol ILayout : AnyObject {
    
    var parent: ILayout? { set get }
    
    var owner: IOwner? { set get }
    
    var frame: Rect { get }
    
    func invalidate()
    
    func invalidate(_ layout: ILayout)
    
    func sizeOf(_ request: SizeRequest) -> Size
    
    func arrange(_ request: ArrangeRequest) -> Size
    
    func collect(_ collector: Collector)
    
}

public extension ILayout {
    
    @inlinable
    func sizeOf(_ request: ArrangeRequest) -> Size {
        return self.sizeOf(.init(request))
    }
    
    @inlinable
    @discardableResult
    func update(on block: () -> Void) -> Self {
        if let owner = self.owner {
            owner.update(on: block)
        } else {
            block()
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func update(on block: (Self) -> Void) -> Self {
        return self.update(on: {
            block(self)
        })
    }
    
    func update() {
        do {
            var parent = self.parent
            var layout: ILayout = self
            while parent != nil {
                guard let safe = parent else { break }
                safe.invalidate(layout)
                parent = safe.parent
                layout = safe
            }
        }
        self.owner?.invalidate()
    }

}

public extension ILayout where Self : IComposite, BodyType : ILayout {
    
    @inlinable
    var parent: ILayout? {
        set { self.body.parent = newValue }
        get { self.body.parent }
    }
    
    @inlinable
    var owner: IOwner? {
        set { self.body.owner = newValue }
        get { self.body.owner }
    }
    
    @inlinable
    var frame: Rect {
        self.body.frame
    }
    
    @inlinable
    func invalidate() {
        self.body.invalidate()
    }
    
    @inlinable
    func invalidate(_ layout: ILayout) {
        self.body.invalidate(layout)
    }
    
    @inlinable
    func sizeOf(_ request: SizeRequest) -> Size {
        return self.body.sizeOf(request)
    }
    
    @inlinable
    func arrange(_ request: ArrangeRequest) -> Size {
        return self.body.arrange(request)
    }
    
    @inlinable
    func collect(_ collector: Collector) {
        self.body.collect(collector)
    }
    
}
