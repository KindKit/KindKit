//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class VAccessoryLayout< LeadingType : ILayout, CenterType : ILayout, TrailingType : ILayout > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self.leading.owner = self.owner
            self.center.owner = self.owner
            self.trailing.owner = self.owner
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @KindMonadicProperty
    public var alignment: HAlignment = .left {
        didSet {
            guard self.alignment != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var leading: LeadingType {
        willSet {
            guard self.leading !== newValue else { return }
            self.leading.owner = nil
            self.leading.parent = nil
        }
        didSet {
            guard self.leading !== oldValue else { return }
            self.leading.parent = self
            self.leading.owner = self.owner
            self.update()
        }
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var center: CenterType {
        willSet {
            guard self.center !== newValue else { return }
            self.center.parent = nil
            self.center.owner = nil
        }
        didSet {
            guard self.center !== oldValue else { return }
            self.center.owner = self.owner
            self.center.parent = self
            self.update()
        }
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyLayout.self)
    @KindMonadicProperty(builder: OneBuilder.self)
    public var trailing: TrailingType {
        willSet {
            guard self.trailing !== newValue else { return }
            self.trailing.parent = nil
            self.trailing.owner = nil
        }
        didSet {
            guard self.trailing !== oldValue else { return }
            self.trailing.owner = self.owner
            self.trailing.parent = self
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var priority: AccessoryPriority = .leadingTrailing {
        didSet {
            guard self.priority != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var filling: Bool = true {
        didSet {
            guard self.filling != oldValue else { return }
            self.update()
        }
    }
    
    public init(
        leading: LeadingType,
        center: CenterType,
        trailing: TrailingType
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
    
    public func invalidate(_ layout: ILayout) {
        if layout === self.leading {
            self.leading.invalidate()
        } else if layout === self.center {
            self.center.invalidate()
        } else if layout === self.trailing {
            self.trailing.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        let sizes = AccessoryHelper.vSize(
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
        let frames = AccessoryHelper.vFrames(
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
