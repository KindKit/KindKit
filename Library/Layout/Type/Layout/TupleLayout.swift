//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class TupleLayout< Primary : Layout, Secondary : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.primary.scope = self.scope
            self.secondary.scope = self.scope
        }
    }
    
    public var frame: Rect {
        return self.primary.frame.union(self.secondary.frame)
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var primary: Primary {
        willSet {
            guard self.primary !== newValue else { return }
            self.primary.scope = nil
            self.primary.parent = nil
        }
        didSet {
            guard self.primary !== oldValue else { return }
            self.primary.parent = self
            self.primary.scope = self.scope
            self.update()
        }
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var secondary: Secondary {
        willSet {
            guard self.secondary !== newValue else { return }
            self.secondary.scope = nil
            self.secondary.parent = nil
        }
        didSet {
            guard self.secondary !== oldValue else { return }
            self.secondary.parent = self
            self.secondary.scope = self.scope
            self.update()
        }
    }
    
    public init(
        _ primary: Primary,
        _ secondary: Secondary
    ) {
        self.primary = primary
        self.secondary = secondary
        
        self.primary.parent = self
        self.secondary.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
        if layout === self.primary {
            self.primary.invalidate()
        } else if layout === self.secondary {
            self.secondary.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        let primarySize = self.primary.sizeOf(request)
        let secondarySize = self.secondary.sizeOf(request)
        return primarySize.max(secondarySize)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let primarySize = self.primary.arrange(request)
        let secondarySize = self.secondary.arrange(request)
        return primarySize.max(secondarySize)
    }
    
    public func collect(_ collector: Collector) {
        self.primary.collect(collector)
        self.secondary.collect(collector)
    }
    
}
