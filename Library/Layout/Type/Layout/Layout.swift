//
//  KindKit
//

import KindGeometry

public protocol Layout : AnyObject, Equatable {
    
    var parent: (any Layout)? { set get }
    
    var scope: Scope? { set get }
    
    var frame: Rect { get }
    
    func invalidate()
    
    func invalidate(_ layout: any Layout)
    
    func sizeOf(_ request: SizeRequest) -> Size
    
    func arrange(_ request: ArrangeRequest) -> Size
    
    func collect(_ collector: Collector)
    
}

public extension Layout {
    
    @inlinable
    func sizeOf(_ request: ArrangeRequest) -> Size {
        return self.sizeOf(.init(request))
    }
    
    @inlinable
    @discardableResult
    func update(on block: () -> Void) -> Self {
        if let owner = self.scope {
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
            var layout: any Layout = self
            while parent != nil {
                guard let safe = parent else { break }
                safe.invalidate(layout)
                parent = safe.parent
                layout = safe
            }
        }
        self.scope?.invalidate()
    }

}

extension Layout {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
}

public extension Layout where Self : CompositorTrait, Body : Layout {
    
    @inlinable
    var parent: (any Layout)? {
        set { self.body.parent = newValue }
        get { self.body.parent }
    }
    
    @inlinable
    var scope: Scope? {
        set { self.body.scope = newValue }
        get { self.body.scope }
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
    func invalidate(_ layout: any Layout) {
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
