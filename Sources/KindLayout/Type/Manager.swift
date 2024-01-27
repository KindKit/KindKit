//
//  KindKit
//

import KindEvent
import KindMath
import KindMonadicMacro

@KindMonadic
public final class Manager< LayoutType : ILayout > : IOwner {
    
    @KindMonadicProperty
    public var holder: IHolder? {
        willSet {
            guard self.holder !== newValue else { return }
            self._clear()
        }
        didSet {
            guard self.holder !== oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var available: DynamicSize = .fit {
        didSet {
            guard self.available != oldValue else { return }
            self._flags.insert(.arrange)
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var viewOrigin: Point = .zero {
        didSet {
            guard self.viewOrigin != oldValue else { return }
            self._flags.insert(.collect)
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var viewSize: Size = .zero {
        didSet {
            guard self.viewSize != oldValue else { return }
            self._flags.insert([ .arrange, .collect ])
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var viewInset: Inset = .zero {
        didSet {
            guard self.viewInset != oldValue else { return }
            self._flags.insert([ .arrange, .collect ])
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var content: LayoutType? {
        willSet {
            guard self.content !== newValue else { return }
            self.content?.owner = nil
            self._clear()
        }
        didSet {
            guard self.content !== oldValue else { return }
            self.content?.owner = self
            self._flags.insert([ .arrange, .collect ])
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var additionalInset: Inset = .zero {
        didSet {
            guard self.additionalInset != oldValue else { return }
            self._flags.insert(.collect)
            self.update()
        }
    }
    
    public private(set) var contentSize = Size.zero {
        didSet {
            guard self.contentSize != oldValue else { return }
            self.onContentSize.emit()
        }
    }
    
    public private(set) var contentItems: [IItem] = []
    
    @KindMonadicSignal
    public let onContentSize = Signal< Void, Void >()
    
    private var _counter = UInt.zero
    private var _flags = Flags.arrange

    public init() {
    }
    
    public func lockUpdate() {
        self._counter += 1
    }
    
    public func unlockUpdate() {
        self._counter -= 1
        self.update()
    }
    
    public func update() {
        if self._counter == 0 {
            self._update()
        }
    }
    
}

public extension Manager {
    
    func invalidate() {
        self._flags.insert(.arrange)
        self._flags.insert(.collect)
        self.update()
    }
    
}

private extension Manager {
    
    func _update() {
        guard let content = self.content else { return }
        if self._flags.contains(.arrange) == true {
            self._flags.remove(.arrange)
            self.contentSize = content.arrange(.init(
                container: self.viewSize,
                available: self.available.resolve(
                    by: self.viewSize.inset(self.viewInset)
                )
            ))
        }
        if let holder = self.holder {
            if self._flags.contains(.collect) == true {
                self._flags.remove(.collect)
                let collector = Collector(bounds: .init(
                    origin: self.viewOrigin,
                    size: self.viewSize.inset(-self.additionalInset)
                ))
                content.collect(collector)
                do {
                    let disappearing = self.contentItems.filter({ item in
                        return collector.items.contains(where: { item === $0 }) == false
                    })
                    for item in disappearing {
                        if item.owner != nil {
                            holder.remove(item)
                            item.owner = nil
                        }
                    }
                }
                for index in 0 ..< collector.items.count {
                    let item = collector.items[index]
                    if item.owner == nil {
                        holder.insert(item, at: index)
                        item.owner = self
                    }
                }
                self.contentItems = collector.items
            }
        }
    }
    
    func _clear() {
        if let holder = self.holder {
            for appeared in self.contentItems {
                if appeared.owner != nil {
                    holder.remove(appeared)
                    appeared.owner = nil
                }
            }
        }
        self.contentItems.removeAll()
        self._flags.insert([ .arrange, .collect ])
    }
    
}
