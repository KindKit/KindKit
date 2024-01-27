//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class TupleLayout< PrimaryType : ILayout, SecondaryType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.primary.owner = self.owner
            self.secondary.owner = self.owner
        }
    }
    
    public var frame: Rect {
        return self.primary.frame.union(self.secondary.frame)
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var primary: PrimaryType {
        willSet {
            guard self.primary !== newValue else { return }
            self.primary.owner = nil
            self.primary.parent = nil
        }
        didSet {
            guard self.primary !== oldValue else { return }
            self.primary.parent = self
            self.primary.owner = self.owner
            self.update()
        }
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var secondary: SecondaryType {
        willSet {
            guard self.secondary !== newValue else { return }
            self.secondary.owner = nil
            self.secondary.parent = nil
        }
        didSet {
            guard self.secondary !== oldValue else { return }
            self.secondary.parent = self
            self.secondary.owner = self.owner
            self.update()
        }
    }
    
    public init(
        _ primary: PrimaryType,
        _ secondary: SecondaryType
    ) {
        self.primary = primary
        self.secondary = secondary
        
        self.primary.parent = self
        self.secondary.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
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
