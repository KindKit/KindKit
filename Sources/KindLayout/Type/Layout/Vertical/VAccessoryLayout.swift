//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class VAccessoryLayout< LeadingType : ILayout, CenterType : ILayout, TrailingType : ILayout > : ILayout {
    
    public weak var parent: ILayout?
    
    public var owner: IOwner? {
        didSet {
            self.leading?.owner = self.owner
            self.center?.owner = self.owner
            self.trailing?.owner = self.owner
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @KindMonadicProperty
    public var leading: LeadingType? {
        willSet {
            guard self.leading !== newValue else { return }
            if let leading = self.leading {
                leading.owner = nil
                leading.parent = nil
            }
        }
        didSet {
            guard self.leading !== oldValue else { return }
            if let leading = self.leading {
                leading.parent = self
                leading.owner = self.owner
            }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var center: CenterType? {
        willSet {
            guard self.center !== newValue else { return }
            if let center = self.center {
                center.owner = nil
                center.parent = nil
            }
        }
        didSet {
            guard self.center !== oldValue else { return }
            if let center = self.center {
                center.parent = self
                center.owner = self.owner
            }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var trailing: TrailingType? {
        willSet {
            guard self.trailing !== newValue else { return }
            if let trailing = self.trailing {
                trailing.owner = nil
                trailing.parent = nil
            }
        }
        didSet {
            guard self.trailing !== oldValue else { return }
            if let trailing = self.trailing {
                trailing.parent = self
                trailing.owner = self.owner
            }
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
    
    public init() {
    }
    
    public func invalidate() {
    }
    
    public func invalidate(_ layout: ILayout) {
        if layout === self.leading {
            self.leading?.invalidate()
        } else if layout === self.center {
            self.center?.invalidate()
        } else if layout === self.trailing {
            self.trailing?.invalidate()
        }
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        let sizes = AccessoryHelper.vSize(
            purpose: request,
            leading: { self.leading?.sizeOf($0) ?? .zero },
            center: { self.center?.sizeOf($0) ?? .zero },
            trailing: { self.trailing?.sizeOf($0) ?? .zero },
            priority: self.priority,
            filling: self.filling
        )
        return sizes.final
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let frames = AccessoryHelper.vFrames(
            purpose: request,
            leading: { self.leading?.sizeOf($0) ?? .zero },
            center: { self.center?.sizeOf($0) ?? .zero },
            trailing: { self.trailing?.sizeOf($0) ?? .zero },
            priority: self.priority,
            filling: self.filling
        )
        self.frame = frames.final
        _ = self.leading?.arrange(.init(
            container: frames.leading
        ))
        _ = self.center?.arrange(.init(
            container: frames.center
        ))
        _ = self.trailing?.arrange(.init(
            container: frames.trailing
        ))
        return frames.final.size
    }
    
    public func collect(_ collector: Collector) {
        switch self.priority {
        case .leadingTrailing:
            self.leading?.collect(collector)
            self.trailing?.collect(collector)
        case .trailingLeading:
            self.trailing?.collect(collector)
            self.leading?.collect(collector)
        }
        self.center?.collect(collector)
    }
    
}

public extension VAccessoryLayout {
    
    @inlinable
    @discardableResult
    func leading< ItemType : IItem >(_ item: ItemType) -> Self where LeadingType == ItemLayout< ItemType > {
        self.leading = ItemLayout(item)
        return self
    }
    
    @inlinable
    @discardableResult
    func center< ItemType : IItem >(_ item: ItemType) -> Self where CenterType == ItemLayout< ItemType > {
        self.center = ItemLayout(item)
        return self
    }
    
    @inlinable
    @discardableResult
    func trailing< ItemType : IItem >(_ item: ItemType) -> Self where TrailingType == ItemLayout< ItemType > {
        self.trailing = ItemLayout(item)
        return self
    }
    
}
