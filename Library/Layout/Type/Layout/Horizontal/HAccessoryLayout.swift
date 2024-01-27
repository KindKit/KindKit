//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class HAccessoryLayout< Leading : Layout, Center : Layout, Trailing : Layout > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self.leading.scope = self.scope
            self.center.scope = self.scope
            self.trailing.scope = self.scope
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @MonadicField
    public var alignment: VAlignment = .top {
        didSet {
            guard self.alignment != oldValue else { return }
            self.update()
        }
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var leading: Leading {
        willSet {
            guard self.leading !== newValue else { return }
            self.leading.scope = nil
            self.leading.parent = nil
        }
        didSet {
            guard self.leading !== oldValue else { return }
            self.leading.parent = self
            self.leading.scope = self.scope
            self.update()
        }
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var center: Center {
        willSet {
            guard self.center !== newValue else { return }
            self.center.parent = nil
            self.center.scope = nil
        }
        didSet {
            guard self.center !== oldValue else { return }
            self.center.scope = self.scope
            self.center.parent = self
            self.update()
        }
    }
    
    @MonadicField
    @MonadicField(default: EmptyLayout.self)
    @MonadicField(builder: OneBuilder.self)
    public var trailing: Trailing {
        willSet {
            guard self.trailing !== newValue else { return }
            self.trailing.parent = nil
            self.trailing.scope = nil
        }
        didSet {
            guard self.trailing !== oldValue else { return }
            self.trailing.scope = self.scope
            self.trailing.parent = self
            self.update()
        }
    }
    
    @MonadicField
    public var priority: AccessoryPriority = .leadingTrailing {
        didSet {
            guard self.priority != oldValue else { return }
            self.update()
        }
    }
    
    @MonadicField
    public var filling: Bool = true {
        didSet {
            guard self.filling != oldValue else { return }
            self.update()
        }
    }
    
    public init(
        leading: Leading,
        center: Center,
        trailing: Trailing
    ) {
        self.leading = leading
        self.center = center
        self.trailing = trailing
        
        self.leading.parent = self
        self.center.parent = self
        self.trailing.parent = self
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: any Layout) {
        if layout === self.leading {
            self.leading.invalidate()
        } else if layout === self.center {
            self.center.invalidate()
        } else if layout === self.trailing {
            self.trailing.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        let sizes = AccessoryHelper.hSize(
            purpose: request,
            leading: self.leading,
            center: self.center,
            trailing: self.trailing,
            priority: self.priority,
            filling: self.filling
        )
        return sizes.final
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let frames = AccessoryHelper.hFrames(
            purpose: request,
            alignment: self.alignment,
            leading: self.leading,
            center: self.center,
            trailing: self.trailing,
            priority: self.priority,
            filling: self.filling
        )
        self.frame = frames.final
        _ = self.leading.arrange(.init(
            container: frames.leading
        ))
        _ = self.center.arrange(.init(
            container: frames.center
        ))
        _ = self.trailing.arrange(.init(
            container: frames.trailing
        ))
        return frames.final.size
    }
    
    public func collect(_ collector: Collector) {
        switch self.priority {
        case .leadingTrailing:
            self.leading.collect(collector)
            self.trailing.collect(collector)
        case .trailingLeading:
            self.trailing.collect(collector)
            self.leading.collect(collector)
        }
        self.center.collect(collector)
    }
    
}
